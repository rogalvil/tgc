# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Orders controller
    class OrdersController < ApplicationController
      before_action :order, only: %i[show update destroy update_status]
      before_action :orders, only: %i[index]

      def index
        authorize! @orders, to: :read?
        render json: serializer(@orders), status: :ok
      end

      def show
        authorize! @order, to: :read?
        render json: serializer(@order), status: :ok
      end

      def create
        @order = current_user.orders.new
        authorize! @order, to: :edit?
        if @order.save
          render json: serializer(@order), status: :created
        else
          render json: { messages: @order.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! @order, to: :edit?
        @order.destroy
        head :no_content
      end

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

      def calculate_total_price(order)
        order.order_items.sum { |order_item| order_item.quantity * order_item.price }
      end
    end
  end
end
