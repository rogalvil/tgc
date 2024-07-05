# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # OrderItems controller
    class OrderItemsController < ApplicationController
      include Api::V1::OrderItemsControllerDoc
      before_action :order
      before_action :order_item, only: %i[show update destroy]

      def index
        @order_items = @order.order_items
        authorize! @order_items, to: :read?
        render json: serializer(@order_items), status: :ok
      end

      def show
        authorize! @order_item, to: :read?
        render json: serializer(@order_item), status: :ok
      end

      def create
        @order_item = @order.order_items.new(order_item_params)
        authorize! @order_item, to: :create?
        if @order_item.save
          render json: serializer(@order_item), status: :created
        else
          render_json_messages(@order_item.errors.full_messages.uniq, :unprocessable_entity)
        end
      end

      def update
        authorize! @order_item, to: :update?
        if @order_item.update(order_item_params)
          render json: serializer(@order_item), status: :ok
        else
          render_json_messages(@order_item.errors.full_messages.uniq, :unprocessable_entity)
        end
      end

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
