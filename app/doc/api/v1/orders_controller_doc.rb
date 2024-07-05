# frozen_string_literal: true

# API module
module Api
  # Version 1 of the APIs
  module V1
    # Orders controller documentation
    module OrdersControllerDoc
      extend Apipie::DSL::Concern

      api :GET, '/orders', 'Retrieve all orders'
      description <<-DESC
        Returns a list of orders.
        - If authenticated as admin, can see all orders.
        - If authenticated as customer, can see only their own orders.
      DESC
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Response Body:
      {
        "data": [
          {
            "id": "1",
            "type": "order",
            "attributes": {
              "total_price": 100.0,
              "status": "pending"
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
      def index; end

      api :GET, '/orders/:id', 'Retrieve an order'
      description <<-DESC
        Returns the details of a specific order.
        - If authenticated as admin, can see any order.
        - If authenticated as customer, can see only their own orders.
      DESC
      param :id, :number, desc: 'ID of the order', required: true
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Response Body:
      {
        "data": {
          "id": "1",
          "type": "order",
          "attributes": {
            "total_price": 100.0,
            "status": "pending"
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
      def show; end

      api :POST, '/orders', 'Create a new order'
      description <<-DESC
        Creates a new order.
        - Only customers can create orders.
      DESC
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Request Body:
      {
        "order": {
          "user_id": 1,
          "total_price": 0.0,
          "status": "pending"
        }
      }

      Response Body:
      {
        "data": {
          "id": "1",
          "type": "order",
          "attributes": {
            "total_price": 0.0,
            "status": "pending",
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
      def create; end

      api :DELETE, '/orders/:id', 'Delete an order'
      description <<-DESC
        Deletes an order.
        - Only the owner of the order or an admin can delete an order.
        - Orders can only be deleted if they are in a pending status.
      DESC
      param :id, :number, desc: 'ID of the order', required: true
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Response Body:
      (No content, status: 204)
      EXAMPLE
      def destroy; end

      api :PATCH, '/v1/orders/:id/status', 'Update the status of an order'
      description <<-DESC
        Updates the status of an order.
        - Only admins can update the status of an order.
      DESC
      param :id, :number, desc: 'ID of the order', required: true
      param :order, Hash, desc: 'Order object', required: true do
        param :status, String, desc: 'New status for the order', required: true
      end
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Request Body:
      {
        "order": {
          "status": "shipped"
        }
      }

      Response Body:
      {
        "data": {
          "id": "1",
          "type": "order",
          "attributes": {
            "total_price": 100.0,
            "status": "shipped"
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
      def update_status; end
    end
  end
end
