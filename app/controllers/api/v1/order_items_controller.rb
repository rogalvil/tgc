# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # OrderItems controller
    class OrderItemsController < ApplicationController
      before_action :order
      before_action :order_item, only: %i[update destroy]

      api :POST, '/api/v1/orders/:order_id/items', 'Create a new order item'
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
      def create
        @order_item = @order.order_items.new(order_item_params)
        authorize! @order_item, to: :create?
        if @order_item.save
          render json: serializer(@order_item), status: :created
        else
          render json: { messages: @order_item.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      api :PATCH, '/api/v1/orders/:order_id/items/:id', 'Update an order item'
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
      def update
        authorize! @order_item, to: :update?
        if @order_item.update(order_item_params)
          render json: serializer(@order_item), status: :ok
        else
          render json: { messages: @order_item.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      api :DELETE, '/v1/orders/:order_id/items/:id', 'Delete an order item'
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
      def destroy
        authorize! @order_item, to: :edit?
        @order_item.destroy
        head :no_content
      end

      private

      def serializer(object)
        OrderItemSerializer.new(object).serializable_hash.to_json
      end

      def order
        @order = orders.find(params[:order_id])
      end

      def orders
        @orders = authorized_scope(Order.all)
      end

      def order_item
        @order_item = @order.order_items.find(params[:id])
      end

      def order_item_params
        params.require(:order_item).permit(:product_id, :quantity)
      end
    end
  end
end
