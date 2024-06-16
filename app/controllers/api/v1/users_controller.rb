# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Users controller
    class UsersController < ApplicationController
      # skip_before_action :authenticate_user!, only: %i[index]

      def index
        users = User.all
        # render json: users, each_serializer: UserSerializer, status: :ok
        render json: UserSerializer.new(users).serializable_hash.to_json, status: :ok
      end
    end
  end
end
