# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Users controller
    class UsersController < ApplicationController
      include ActionPolicy::Controller
      before_action :user, only: %i[show update]
      before_action :users, only: %i[index]

      def index
        authorize! User, to: :read?
        render json: serializer(@users), status: :ok
      end

      def show
        authorize! @user, to: :show?
        render json: serializer(@user), status: :ok
      end

      def update
        authorize! @user, to: :update?
        if @user.update(user_params)
          render json: serializer(@user), status: :ok
        else
          render json: { messages: @user.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      private

      def serializer(object)
        UserSerializer.new(object).serializable_hash.to_json
      end

      def user
        @user = users.find(params[:id])
      end

      def users
        @users = authorized_scope(User.all)
      end

      def user_params
        params.require(:user).permit(:name, :email)
      end
    end
  end
end
