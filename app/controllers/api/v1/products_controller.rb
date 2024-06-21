# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Products controller
    class ProductsController < ApplicationController
      before_action :product, only: %i[show update destroy update_stock update_status]
      before_action :products, only: %i[index]
      skip_before_action :authenticate_user!, only: %i[index show]

      def index
        @products = authorized_scope(@products)
        authorize! @products, to: :read?
        render json: serializer(@products), status: :ok
      end

      def show
        authorize! @product, to: :read?
        render json: serializer(@product), status: :ok
      end

      def create
        @product = Product.new(product_params)
        authorize! @product, to: :edit?
        if @product.save
          render json: serializer(@product), status: :created
        else
          render json: { messages: @product.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      def update
        authorize! @product, to: :edit?
        if @product.update(product_params)
          render json: serializer(@product), status: :ok
        else
          render json: { messages: @product.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! @product, to: :edit?
        @product.destroy
        head :no_content
      end

      def update_stock
        authorize! @product, to: :edit?
        if @product.update(stock_params)
          render json: serializer(@product), status: :ok
        else
          render json: { messages: @product.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      def update_status
        authorize! @product, to: :edit?
        if @product.update(status_params)
          render json: serializer(@product), status: :ok
        else
          render json: { messages: @product.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      private

      def serializer(object)
        ProductSerializer.new(object).serializable_hash.to_json
      end

      def product
        @product = products.find(params[:id])
      end

      def products
        @products = authorized_scope(Product.all)
      end

      def product_params
        params.require(:product).permit(:sku, :name, :description, :price, :stock)
      end

      def stock_params
        params.require(:product).permit(:stock)
      end

      def status_params
        params.require(:product).permit(:status)
      end
    end
  end
end
