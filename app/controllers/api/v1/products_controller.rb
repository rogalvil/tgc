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

      api :GET, '/v1/products', 'Retrieve products'
      description <<-DESC
        Returns a list products.
        - If authenticated as admin, returns all products.
        - If authenticated as customer, returns only active and preorder products.
        - Supports search by query parameter for product name or description.
      DESC
      param :query, String, desc: 'Search query for product name or description', required: false
      example <<-EXAMPLE
      {
        "data": [
          {
            "id": "1",
            "type": "product",
            "attributes": {
              "id": 1,
              "sku": "SKU1",
              "name": "Product 1",
              "description": "Description 1",
              "price": 10.0,
              "stock": 100,
              "status": "active"
            }
          },
          {
            "id": "2",
            "type": "product",
            "attributes": {
              "id": 2,
              "sku": "SKU2",
              "name": "Product 2",
              "description": "Description 2",
              "price": 20.0,
              "stock": 50,
              "status": "preorder"
            }
          }
        ]
      }
      EXAMPLE
      def index
        @products = authorized_scope(@products)
        @products = @products.search(params[:query]) if params[:query].present?
        authorize! @products, to: :index?
        render json: serializer(@products), status: :ok
      end

      api :GET, '/api/v1/products/:id', 'Retrieve a product'
      description <<-DESC
        Returns the details of a product.
        - If authenticated as admin, can see all products.
        - If authenticated as customer, can see only active and preorder products.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
            "id": 1,
            "sku": "SKU1",
            "name": "Product 1",
            "description": "Description 1",
            "price": 10.0,
            "stock": 100,
            "status": "active"
          }
        }
      }
      EXAMPLE
      def show
        authorize! @product, to: :show?
        render json: serializer(@product), status: :ok
      end

      api :POST, '/api/v1/products', 'Create a new product'
      description <<-DESC
        Creates a new product. Only admins can create products.
      DESC
      param :product, Hash, desc: 'Product information', required: true do
        param :sku, String, desc: 'SKU of the product', required: true
        param :name, String, desc: 'Name of the product', required: true
        param :price, :number, desc: 'Price of the product', required: true
        param :stock, :number, desc: 'Stock of the product', required: true
        param :description, String, desc: 'Description of the product', required: false
      end
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
            "id": 1,
            "sku": "SKU1",
            "name": "Product 1",
            "description": "Description 1",
            "price": 10.0,
            "stock": 100,
            "status": "active"
          }
        }
      }
      EXAMPLE
      def create
        @product = Product.new(product_params)
        authorize! @product, to: :edit?
        if @product.save
          render json: serializer(@product), status: :created
        else
          render json: { messages: @product.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      api :PUT, '/api/v1/products/:id', 'Update a product'
      description <<-DESC
        Updates a product. Only admins can update products.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
      param :product, Hash, desc: 'Product information', required: true do
        param :sku, String, desc: 'SKU of the product', required: false
        param :name, String, desc: 'Name of the product', required: false
        param :description, String, desc: 'Description of the product', required: false
        param :price, :number, desc: 'Price of the product', required: false
        param :stock, :number, desc: 'Stock of the product', required: false
      end
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
            "id": 1,
            "sku": "SKU1",
            "name": "Product 1",
            "description": "Description 1",
            "price": 10.0,
            "stock": 100,
            "status": "active"
          }
        }
      }
      EXAMPLE
      def update
        authorize! @product, to: :edit?
        if @product.update(product_params)
          render json: serializer(@product), status: :ok
        else
          render json: { messages: @product.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      api :DELETE, '/api/v1/products/:id', 'Delete a product'
      description <<-DESC
        Deletes a product. Only admins can delete products.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
      example <<-EXAMPLE
      {
        "status": "204 No Content"
      }
      EXAMPLE
      def destroy
        authorize! @product, to: :edit?
        @product.destroy
        head :no_content
      end

      api :PATCH, '/api/v1/products/:id/stock', 'Update the stock of a product'
      description <<-DESC
        Updates the stock of a product. Only admins can update the stock.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
      param :stock, :number, desc: 'New stock of the product', required: true
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
            "id": 1,
            "sku": "SKU1",
            "name": "Product 1",
            "description": "Description 1",
            "price": 10.0,
            "stock": 100,
            "status": "active"
          }
        }
      }
      EXAMPLE
      def update_stock
        authorize! @product, to: :edit?
        if @product.update(stock_params)
          render json: serializer(@product), status: :ok
        else
          render json: { messages: @product.errors.full_messages.uniq }, status: :unprocessable_entity
        end
      end

      api :PATCH, '/api/v1/products/:id/status', 'Update the status of a product'
      description <<-DESC
        Updates the status of a product. Only admins can update the status.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
      param :status, String, desc: 'New status of the product', required: true
      example <<-EXAMPLE
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
            "id": 1,
            "sku": "SKU1",
            "name": "Product 1",
            "description": "Description 1",
            "price": 10.0,
            "stock": 100,
            "status": "active"
          }
        }
      }
      EXAMPLE
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
