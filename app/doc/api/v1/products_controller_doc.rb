# frozen_string_literal: true

# API module
module Api
  # Version 1 of the APIs
  module V1
    # Products controller documentation
    module ProductsControllerDoc
      extend Apipie::DSL::Concern

      api :GET, '/products', 'Retrieve all products'
      description <<-DESC
        Returns a list products.
        - If authenticated as admin, returns all products.
        - If authenticated as customer or guest, returns only active and preorder products.
        - Supports search by query parameter for product name or description.
      DESC
      param :query, String, desc: 'Search query for product name or description', required: false
      header 'Authorization', 'Bearer token', required: false
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
            "type": "product",
            "attributes": {
              "sku": "SKU1",
              "name": "Product 1",
              "description": "Description 1",
              "price": 10.0,
              "stock": 100,
              "status": "active"
            }
          },
          {
            "id": 2,
            "type": "product",
            "attributes": {
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
      def index; end

      api :GET, '/products/:id', 'Retrieve a product'
      description <<-DESC
        Returns the details of a product.
        - If authenticated as admin, can see all products.
        - If authenticated as customer or guest, can see only active and preorder products.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
      header 'Authorization', 'Bearer token', required: false
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Response Body:
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
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
      def show; end

      api :POST, '/products', 'Create a new product'
      description <<-DESC
        Creates a new product. Only admins can create products.
      DESC
      param :product, Hash, desc: 'Product information', required: true do
        param :sku, String, desc: 'SKU of the product', required: true
        param :name, String, desc: 'Name of the product', required: true
        param :price, :decimal, desc: 'Price of the product', required: true
        param :stock, :number, desc: 'Stock of the product', required: true
        param :description, String, desc: 'Description of the product', required: false
      end
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Request Body:
      {
        "product": {
          "sku": "SKU1",
          "name": "Product 1",
          "price": 10.0,
          "stock": 100,
          "description": "Description 1"
        }
      }

      Response Body:
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
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
      def create; end

      api :PATCH, '/products/:id', 'Update a product'
      description <<-DESC
        Updates a product. Only admins can update products.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
      param :product, Hash, desc: 'Product information', required: true do
        param :sku, String, desc: 'SKU of the product', required: false
        param :name, String, desc: 'Name of the product', required: false
        param :description, String, desc: 'Description of the product', required: false
        param :price, :decimal, desc: 'Price of the product', required: false
        param :stock, :number, desc: 'Stock of the product', required: false
      end
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Request Body:
      {
        "product": {
          "sku": "UPDATEDSKU",
          "name": "Updated Product",
          "description": "Updated Description",
          "price": 20.0,
          "stock": 200
        }
      }

      Response Body:
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
            "sku": "SKU1",
            "name": "Updated Product",
            "description": "Updated Description",
            "price": 20.0,
            "stock": 200,
            "status": "active"
          }
        }
      }
      EXAMPLE
      def update; end

      api :DELETE, '/products/:id', 'Delete a product'
      description <<-DESC
        Deletes a product. Only admins can delete products.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
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

      api :PATCH, '/products/:id/stock', 'Update the stock of a product'
      description <<-DESC
        Updates the stock of a product. Only admins can update the stock.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
      param :product, Hash, desc: 'Product information', required: true do
        param :stock, :number, desc: 'New stock of the product', required: true
      end
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Request Body:
      {
        "product": {
          "stock": 200
        }
      }

      Response Body:
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
            "sku": "SKU1",
            "name": "Product 1",
            "description": "Description 1",
            "price": 10.0,
            "stock": 200,
            "status": "active"
          }
        }
      }
      EXAMPLE
      def update_stock; end

      api :PATCH, '/products/:id/status', 'Update the status of a product'
      description <<-DESC
        Updates the status of a product. Only admins can update the status.
      DESC
      param :id, :number, desc: 'ID of the product', required: true
      param :product, Hash, desc: 'Product information', required: true do
        param :status, String, desc: 'New status of the product. Allowed values: active, inactive, discontinued, preorder', required: true
      end
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Request Body:
      {
        "product": {
          "status": "discontinued"
        }
      }

      Response Body:
      {
        "data": {
          "id": "1",
          "type": "product",
          "attributes": {
            "sku": "SKU1",
            "name": "Product 1",
            "description": "Description 1",
            "price": 10.0,
            "stock": 100,
            "status": "discontinued"
          }
        }
      }
      EXAMPLE
      def update_status; end
    end
  end
end
