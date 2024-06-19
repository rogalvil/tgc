# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Users controller
    class UsersController < ApplicationController
      include ActionPolicy::Controller
      before_action :user, only: %i[show]

      def index
        authorize! User, to: :index?
        users = User.all
        render json: UserSerializer.new(users).serializable_hash.to_json, status: :ok
      end

      def customers
        authorize! User, to: :customers?
        users = User.where(role: 'customer')
        render json: UserSerializer.new(users).serializable_hash.to_json, status: :ok
      end

      def show
        authorize! @user, to: :show?
        render json: UserSerializer.new(@user).serializable_hash.to_json, status: :ok
      end

      private

      def user
        @user = User.find(params[:id])
      end
    end
  end
end
