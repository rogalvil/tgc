# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Orders controller
    class OrdersController < ApplicationController
      before_action :order, only: %i[show destroy update_status]
      before_action :orders, only: %i[index]

      api :GET, '/api/v1/orders', 'Retrieve all orders'
      description <<-DESC
        Returns a list of orders.
        - If authenticated as admin, can see all orders.
        - If authenticated as customer, can see only their own orders.
      DESC
      example <<-EXAMPLE
      {
        "data": [
          {
            "id": "1",
            "type": "order",
            "attributes": {
              "id": 1,
              "total_price": 100.0,
              "status": "pending",
              "created_at": "2024-06-22T00:00:00.000Z",
              "updated_at": "2024-06-22T00:00:00.000Z"
            },
            "relationships": {
              "user": {
                "data": {
                  "id": "1",
                  "type": "user"
                }
              },
              "order_items": {
                "data": [
                  {
                    "id": "1",
                    "type": "order_item"
                  }
                ]
              }
            }
          }
        ]
      }
      EXAMPLE
      def index
        authorize! @orders, to: :index?
        render json: serializer(@orders), status: :ok
      end

      api :GET, '/api/v1/orders/:id', 'Retrieve an order'
      description <<-DESC
        Returns the details of a specific order.
        - If authenticated as admin, can see any order.
        - If authenticated as customer, can see only their own orders.
      DESC
      param :id, :number, desc: 'ID of the order', required: true
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "order",
          "attributes": {
            "id": 1,
            "total_price": 100.0,
            "status": "pending",
            "created_at": "2024-06-22T00:00:00.000Z",
            "updated_at": "2024-06-22T00:00:00.000Z"
          },
          "relationships": {
            "user": {
              "data": {
                "id": "1",
                "type": "user"
              }
            },
            "order_items": {
              "data": [
                {
                  "id": "1",
                  "type": "order_item"
                }
              ]
            }
          }
        }
      }
      EXAMPLE
      def show
        authorize! @order, to: :read?
        render json: serializer(@order), status: :ok
      end

      api :POST, '/api/v1/orders', 'Create a new order'
      description <<-DESC
        Creates a new order.
        - Only customers can create orders.
      DESC
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "order",
          "attributes": {
            "id": 1,
            "total_price": 0.0,
            "status": "pending",
            "user_id": 1,
            "created_at": "2024-06-22T00:00:00.000Z",
            "updated_at": "2024-06-22T00:00:00.000Z"
          },
          "relationships": {
            "user": {
              "data": {
                "id": "1",
                "type": "user"
              }
            },
            "order_items": {
              "data": []
            }
          }
        }
      }
      EXAMPLE
      def create
        @order = current_user.orders.new
        authorize! @order, to: :create?
        if @order.save
          render json: serializer(@order), status: :created
        else
          render json: { messages: @order.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      api :DELETE, '/api/v1/orders/:id', 'Delete an order'
      description <<-DESC
        Deletes an order.
        - Only the owner of the order or an admin can delete an order.
        - Orders can only be deleted if they are in a pending status.
      DESC
      param :id, :number, desc: 'ID of the order', required: true
      example <<-EXAMPLE
      {
        "status": "204 No Content"
      }
      EXAMPLE
      def destroy
        authorize! @order, to: :destroy?
        @order.destroy
        head :no_content
      end

      api :PATCH, '/v1/orders/:id/status', 'Update the status of an order'
      description <<-DESC
        Updates the status of an order.
        - Only admins can update the status of an order.
      DESC
      param :id, :number, desc: 'ID of the order', required: true
      param :order, Hash, desc: 'Order object', required: true do
        param :status, String, desc: 'New status for the order', required: true
      end
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "order",
          "attributes": {
            "id": 1,
            "total_price": 100.0,
            "status": "shipped",
            "user_id": 1,
            "created_at": "2024-06-22T00:00:00.000Z",
            "updated_at": "2024-06-22T00:00:00.000Z"
          },
          "relationships": {
            "user": {
              "data": {
                "id": "1",
                "type": "user"
              }
            },
            "order_items": {
              "data": [
                {
                  "id": "1",
                  "type": "order_item"
                }
              ]
            }
          }
        }
      }
      EXAMPLE
      def update_status
        authorize! @order, to: :edit?
        if @order.update(status_params)
          render json: serializer(@order), status: :ok
        else
          render json: { messages: @order.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      private

      def serializer(object)
        OrderSerializer.new(object).serializable_hash.to_json
      end

      def order
        @order = orders.find(params[:id])
      end

      def orders
        @orders = authorized_scope(Order.all)
      end

      def status_params
        params.require(:order).permit(:status)
      end
    end
  end
end
