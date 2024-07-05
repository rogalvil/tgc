# frozen_string_literal: true

# API module
module Api
  # Version 1 of the APIs
  module V1
    # Order Items controller documentation
    module OrderItemsControllerDoc
      extend Apipie::DSL::Concern

      api :GET, '/orders/:order_id/items', 'Retrieve all items for an order'
      description <<-DESC
        Retrieves all items for an order.
        - Only the owner of the order or an admin can view the items.
      DESC
      param :order_id, :number, desc: 'ID of the order', required: true
      example <<-EXAMPLE
      {
        "data": [
          {
            "id": "1",
            "type": "order_item",
            "attributes": {
              "quantity": 2,
              "price": 50.0
            },
            "relationships": {
              "order": {
                "data": {
                  "id": "1",
                  "type": "order"
                }
              },
              "product": {
                "data": {
                  "id": "1",
                  "type": "product"
                }
              }
            }
          },
          {
            "id": "2",
            "type": "order_item",
            "attributes": {
              "quantity": 1,
              "price": 30.0
            },
            "relationships": {
              "order": {
                "data": {
                  "id": "1",
                  "type": "order"
                }
              },
              "product": {
                "data": {
                  "id": "2",
                  "type": "product"
                }
              }
            }
          }
        ]
      }
      EXAMPLE
      def index; end

      api :GET, '/orders/:order_id/items/:id', 'Retrieve an item for an order'
      description <<-DESC
        Retrieves an item for an order.
        - Only the owner of the order or an admin can view the item.
      DESC
      param :order_id, :number, desc: 'ID of the order', required: true
      param :id, :number, desc: 'ID of the order item', required: true
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "order_item",
          "attributes": {
            "quantity": 2,
            "price": 50.0
          },
          "relationships": {
            "order": {
              "data": {
                "id": "1",
                "type": "order"
              }
            },
            "product": {
              "data": {
                "id": "1",
                "type": "product"
              }
            }
          }
        }
      }
      EXAMPLE
      def show; end

      api :POST, '/orders/:order_id/items', 'Create a new order item'
      description <<-DESC
        Creates a new order item.
        - Only the owner of the order or an admin can create an item.
      DESC
      param :order_id, :number, desc: 'ID of the order', required: true
      param :order_item, Hash, desc: 'Order item parameters', required: true do
        param :product_id, :number, desc: 'ID of the product', required: true
        param :quantity, :number, desc: 'Quantity of the product', required: true
      end
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "order_item",
          "attributes": {
            "quantity": 2,
            "price": 50.0
          },
          "relationships": {
            "order": {
              "data": {
                "id": "1",
                "type": "order"
              }
            },
            "product": {
              "data": {
                "id": "1",
                "type": "product"
              }
            }
          }
        }
      }
      EXAMPLE
      def create; end

      api :PATCH, '/orders/:order_id/items/:id', 'Update an order item'
      description <<-DESC
        Updates an order item.
        - Only the owner of the order or an admin can update an item.
        - The order must be in pending status to update items.
      DESC
      param :order_id, :number, desc: 'ID of the order', required: true
      param :id, :number, desc: 'ID of the order item', required: true
      param :order_item, Hash, desc: 'Order item parameters', required: true do
        param :quantity, :number, desc: 'Quantity of the product', required: true
      end
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "order_item",
          "attributes": {
            "quantity": 3,
            "price": 50.0
          },
          "relationships": {
            "order": {
              "data": {
                "id": "1",
                "type": "order"
              }
            },
            "product": {
              "data": {
                "id": "1",
                "type": "product"
              }
            }
          }
        }
      }
      EXAMPLE
      def update; end

      api :DELETE, '/orders/:order_id/items/:id', 'Delete an order item'
      description <<-DESC
        Deletes an order item.
        - Only the owner of the order or an admin can delete an item.
        - The order must be in pending status to delete items.
      DESC
      param :order_id, :number, desc: 'ID of the order', required: true
      param :id, :number, desc: 'ID of the order item', required: true
      example <<-EXAMPLE
      {
        "status": "204 No Content"
      }
      EXAMPLE
      def destroy; end
    end
  end
end
