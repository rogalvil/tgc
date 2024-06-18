# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Users controller
    class UsersController < ApplicationController
      include ActionPolicy::Controller

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
    end
  end
end
