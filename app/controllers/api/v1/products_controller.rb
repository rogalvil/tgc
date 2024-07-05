# frozen_string_literal: true

# API module
module Api
  # Version 1 of the API
  module V1
    # Products controller
    class ProductsController < ApplicationController
      include Api::V1::ProductsControllerDoc
      before_action :product, only: %i[show update destroy update_stock update_status]
      before_action :products, only: %i[index]
      skip_before_action :authenticate_user!, only: %i[index show]

      def index
        @products = authorized_scope(@products)
        @products = @products.search(params[:query]) if params[:query].present?
        authorize! @products, to: :index?
        render json: serializer(@products), status: :ok
      end

      def show
        authorize! @product, to: :show?
        render json: serializer(@product), status: :ok
      end

      def create
        @product = Product.new(product_params)
        authorize! @product, to: :create?
        if @product.save
          render json: serializer(@product), status: :created
        else
          render_json_messages(@product.errors.full_messages.uniq, :unprocessable_entity)
        end
      end

      def update
        authorize! @product, to: :update?
        if @product.update(product_params)
          render json: serializer(@product), status: :ok
        else
          render_json_messages(@product.errors.full_messages.uniq, :unprocessable_entity)
        end
      end

      def destroy
        authorize! @product, to: :destroy?
        @product.destroy
        head :no_content
      end

      def update_stock
        authorize! @product, to: :update_stock?
        if @product.update(stock_params)
          render json: serializer(@product), status: :ok
        else
          render_json_messages(@product.errors.full_messages.uniq, :unprocessable_entity)
        end
      end

      def update_status
        authorize! @product, to: :update_status?
        if @product.update(status_params)
          render json: serializer(@product), status: :ok
        else
          render_json_messages(@product.errors.full_messages.uniq, :unprocessable_entity)
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
