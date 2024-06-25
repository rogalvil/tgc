# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Users controller
    class UsersController < ApplicationController
      before_action :user, only: %i[show update destroy]
      before_action :users, only: %i[index]

      api :GET, '/api/v1/users', 'List all users'
      description <<-DESC
        Retrieves a list of all users. Only admins can access this endpoint.
      DESC
      example <<-EXAMPLE
        {
          "data": [
            {
              "id": 1,
              "email": "user1@example.com",
              "role": "admin"
            },
            {
              "id": 2,
              "email": "user2@example.com",
              "role": "customer"
            }
          ]
        }
      EXAMPLE
      def index
        authorize! User, to: :index?
        render json: serializer(@users), status: :ok
      end

      api :GET, '/api/v1/users/:id', 'Show a user'
      description <<-DESC
        Retrieves the details of a specific user. Only admins and the user themselves can access this endpoint.
      DESC
      param :id, :number, desc: 'ID of the user', required: true
      example <<-EXAMPLE
        {
          "data": {
            "id": 1,
            "email": "user@example.com",
            "role": "customer"
          }
        }
      EXAMPLE
      def show
        authorize! @user, to: :show?
        render json: serializer(@user), status: :ok
      end

      api :POST, '/api/v1/users', 'Create a new user'
      description <<-DESC
        Creates a new user. Only admins can create users.
      DESC
      param :user, Hash, desc: 'User information', required: true do
        param :email, String, desc: 'Email of the user', required: true
        param :name, String , desc: 'Name of the user', required: true
        param :password, String, desc: 'Password of the user', required: true
      end
      example <<-EXAMPLE
        {
          "data": {
            "id": 1,
            "email": "newuser@example.com",
            "role": "customer"
          }
        }
      EXAMPLE
      def create
        @user = users.new(user_params)
        authorize! @user, to: :create?
        if @user.save
          render json: serializer(@user), status: :created
        else
          render json: { messages: @user.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      api :PUT, '/api/v1/users/:id', 'Update a user'
      description <<-DESC
        Updates the details of a specific user. Only admins and the user themselves can update this endpoint.
      DESC
      param :id, :number, desc: 'ID of the user', required: true
      param :user, Hash, desc: 'User information', required: true do
        param :email, String, desc: 'Email of the user', required: false
        param :password, String, desc: 'Password of the user', required: false
        param :role, String, desc: 'Role of the user', required: false
      end
      example <<-EXAMPLE
        {
          "data": {
            "id": 1,
            "email": "updateduser@example.com",
            "role": "customer"
          }
        }
      EXAMPLE
      def update
        authorize! @user, to: :update?
        if @user.update(user_params)
          render json: serializer(@user), status: :ok
        else
          render json: { messages: @user.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      api :DELETE, '/api/v1/users/:id', 'Delete a user'
      description <<-DESC
        Deletes a specific user. Only admins can delete users.
      DESC
      param :id, :number, desc: 'ID of the user', required: true
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
    end
  end
end
