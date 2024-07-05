# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Users controller
    class UsersController < ApplicationController
      include Api::V1::UsersControllerDoc

      before_action :user, only: %i[show update destroy]
      before_action :users, only: %i[index]

      def index
        authorize! User, to: :index?
        render json: serializer(@users), status: :ok
      end

      def show
        authorize! @user, to: :show?
        render json: serializer(@user), status: :ok
      end

      def create
        @user = users.new(user_params)
        authorize! @user, to: :create?
        if @user.save
          render json: serializer(@user), status: :created
        else
          render_json_messages(@user.errors.full_messages.uniq, :unprocessable_entity)
        end
      end

      def update
        authorize! @user, to: :update?
        if @user.update(user_update_params)
          render json: serializer(@user), status: :ok
        else
          render_json_messages(@user.errors.full_messages.uniq, :unprocessable_entity)
        end
      end

      def destroy
        authorize! @user, to: :destroy?
        @user.destroy
        head :no_content
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
        params.require(:user).permit(:name, :email, :password, :role)
      end

      def user_update_params
        params.require(:user).permit(:name)
      end
    end
  end
end
