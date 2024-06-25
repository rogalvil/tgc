# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user, :customer) }
  let(:guest) { create(:user) }
  let(:active_product) { create(:product, :active) }
  let(:inactive_product) { create(:product, :inactive) }
  let(:discontinued_product) { create(:product, :discontinued) }
  let(:preorder_product) { create(:product, :preorder) }
  let(:all_products) { [active_product, inactive_product, discontinued_product, preorder_product] }

  describe 'GET /api/v1/products' do
    context 'when authenticated as admin' do
      before do
        all_products
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'returns a list of all products' do
        get '/api/v1/products', headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        all_products.each do |product|
          expect(json['data'].any? { |p| p['id'].to_i == product.id }).to be_truthy
        end
        expect(json['data'].size).to eq(all_products.size)
        expect(response).to have_http_status(:ok)
      end

      it 'returns a filtered list of products by name' do
        get '/api/v1/products', params: { query: active_product.name }, headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        expect(json['data'].size).to eq(1)
        expect(json['data'].first['id'].to_i).to eq(active_product.id)
        expect(response).to have_http_status(:ok)
      end

      it 'returns a filtered list of products by description' do
        get '/api/v1/products', params: { query: active_product.description.split(" ").first }, headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        expect(json['data'].size).to eq(1)
        expect(json['data'].first['id'].to_i).to eq(active_product.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as customer' do
      before do
        all_products
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'returns a list of active and preorder products only' do
        get '/api/v1/products', headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        expect(json['data'].any? { |p| p['id'].to_i == active_product.id }).to be_truthy
        expect(json['data'].any? { |p| p['id'].to_i == preorder_product.id }).to be_truthy
        expect(json['data'].any? { |p| p['id'].to_i == inactive_product.id }).to be_falsey
        expect(json['data'].any? { |p| p['id'].to_i == discontinued_product.id }).to be_falsey
        expect(json['data'].size).to eq(2)
        expect(response).to have_http_status(:ok)
      end

      it 'returns a filtered list of products by name' do
        get '/api/v1/products', params: { query: active_product.name }, headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        expect(json['data'].size).to eq(1)
        expect(json['data'].first['id'].to_i).to eq(active_product.id)
        expect(response).to have_http_status(:ok)
      end

      it 'returns a filtered list of products by description' do
        get '/api/v1/products', params: { query: active_product.description.split(" ").first }, headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        expect(json['data'].size).to eq(1)
        expect(json['data'].first['id'].to_i).to eq(active_product.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not authenticated' do
      before { all_products }

      it 'returns a list of active and preorder products only' do
        get '/api/v1/products'
        expect(json).not_to be_empty
        expect(json['data'].any? { |p| p['id'].to_i == active_product.id }).to be_truthy
        expect(json['data'].any? { |p| p['id'].to_i == preorder_product.id }).to be_truthy
        expect(json['data'].any? { |p| p['id'].to_i == inactive_product.id }).to be_falsey
        expect(json['data'].any? { |p| p['id'].to_i == discontinued_product.id }).to be_falsey
        expect(json['data'].size).to eq(2)
        expect(response).to have_http_status(:ok)
      end

      it 'returns a filtered list of products by name' do
        get '/api/v1/products', params: { query: active_product.name }, headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        expect(json['data'].size).to eq(1)
        expect(json['data'].first['id'].to_i).to eq(active_product.id)
        expect(response).to have_http_status(:ok)
      end

      it 'returns a filtered list of products by description' do
        get '/api/v1/products', params: { query: active_product.description.split(" ").first }, headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        expect(json['data'].size).to eq(1)
        expect(json['data'].first['id'].to_i).to eq(active_product.id)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /api/v1/products/:id' do
    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'returns the product regardless of status' do
        all_products.each do |product|
          get "/api/v1/products/#{product.id}", headers: { 'Authorization': @auth_token }
          expect(json['data']['id'].to_i).to eq(product.id)
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'returns active and preorder products' do
        [active_product, preorder_product].each do |product|
          get "/api/v1/products/#{product.id}", headers: { 'Authorization': @auth_token }
          expect(json['data']['id'].to_i).to eq(product.id)
          expect(response).to have_http_status(:ok)
        end
      end

      it 'returns status code 404 for inactive and discontinued products' do
        [inactive_product, discontinued_product].each do |product|
          get "/api/v1/products/#{product.id}", headers: { 'Authorization': @auth_token }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when not authenticated' do
      it 'returns active and preorder products' do
        [active_product, preorder_product].each do |product|
          get "/api/v1/products/#{product.id}"
          expect(json['data']['id'].to_i).to eq(product.id)
          expect(response).to have_http_status(:ok)
        end
      end

      it 'returns status code 404 for inactive and discontinued products' do
        [inactive_product, discontinued_product].each do |product|
          get "/api/v1/products/#{product.id}"
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST /api/v1/products' do
    let(:valid_attributes) do
      {
        product: {
          sku: 'SKU123', name: 'New Product',
          description: 'New product description', price: 100.00,
          stock: 10
        }
      }
    end

    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'creates a product' do
        post '/api/v1/products', params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['sku']).to eq('SKU123')
        expect(json['data']['attributes']['name']).to eq('New Product')
        expect(json['data']['attributes']['description']).to eq('New product description')
        expect(json['data']['attributes']['price'].to_f).to eq(100.0)
        expect(json['data']['attributes']['stock']).to eq(10)
        expect(json['data']['attributes']['status']).to eq('inactive')
        expect(response).to have_http_status(:created)
      end

      it 'returns status code bad request with invalid attributes' do
        invalid_attributes = { product: { name: '', price: 0, stock: -1 } }
        post '/api/v1/products', params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'returns status code 403' do
        post '/api/v1/products', params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        post '/api/v1/products', params: valid_attributes
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/v1/products/:id' do
    let(:valid_attributes) do
      {
        product: {
          sku: 'SKU123UPDATED', name: 'Updated Product',
          description: 'Updated product description', price: 1000.00,
          stock: 1000
        }
      }
    end

    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'updates the product' do
        put "/api/v1/products/#{active_product.id}", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['sku']).to eq('SKU123UPDATED')
        expect(json['data']['attributes']['name']).to eq('Updated Product')
        expect(json['data']['attributes']['description']).to eq('Updated product description')
        expect(json['data']['attributes']['price'].to_f).to eq(1000.0)
        expect(json['data']['attributes']['stock']).to eq(1000)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the price rounded if it has more decimals' do
        invalid_attributes = { product: { price: 54.6999 } }
        put "/api/v1/products/#{active_product.id}", params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['price'].to_f).to eq(54.70)
        expect(response).to have_http_status(:ok)
      end

      it 'returns status code bad request with invalid sku' do
        invalid_attributes = { product: { sku: '' } }
        put "/api/v1/products/#{active_product.id}", params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns status code bad request with invalid name' do
        invalid_attributes = { product: { name: '' } }
        put "/api/v1/products/#{active_product.id}", params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns status code bad request with invalid price' do
        invalid_attributes = { product: { price: 'a' } }
        put "/api/v1/products/#{active_product.id}", params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns status code unprocessable with negative price' do
        invalid_attributes = { product: { price: -1000 } }
        put "/api/v1/products/#{active_product.id}", params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['messages']).to include('Price must be greater than or equal to 0')
        expect(response).to have_http_status(422)
      end

      it 'returns status code bad request with invalid stock' do
        invalid_attributes = { product: { stock: -10 } }
        put "/api/v1/products/#{active_product.id}", params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'returns status code 403' do
        put "/api/v1/products/#{active_product.id}", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        put "/api/v1/products/#{active_product.id}", params: valid_attributes
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'deletes the product' do
        delete "/api/v1/products/#{active_product.id}", headers: { 'Authorization': @auth_token }
        expect { active_product.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'returns status code 403' do
        delete "/api/v1/products/#{active_product.id}", headers: { 'Authorization': @auth_token }
        expect { active_product.reload }.not_to raise_error
        expect(active_product.status).to eq('active')
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        delete "/api/v1/products/#{active_product.id}"
        expect { active_product.reload }.not_to raise_error
        expect(active_product.status).to eq('active')
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/products/:id/stock' do
    let(:valid_attributes) { { product: { stock: 20 } } }

    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'updates the stock of the product' do
        patch "/api/v1/products/#{active_product.id}/stock", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['stock']).to eq(20)
        expect(response).to have_http_status(:ok)
      end

      it 'returns status code bad request with invalid attributes' do
        invalid_attributes = { product: { stock: -5 } }
        patch "/api/v1/products/#{active_product.id}/stock", params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'returns status code 403' do
        patch "/api/v1/products/#{active_product.id}/stock", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        patch "/api/v1/products/#{active_product.id}/stock", params: valid_attributes
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/products/:id/status' do
    let(:valid_attributes) { { product: { status: 'inactive' } } }
    let(:invalid_attributes) { { product: { status: '' } } }

    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'updates the status of the product' do
        patch "/api/v1/products/#{active_product.id}/status", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['status']).to eq('inactive')
        expect(response).to have_http_status(:ok)
      end

      it 'returns status bad request status with invalid attributes' do
        patch "/api/v1/products/#{active_product.id}/status", params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['messages']).to include('Invalid parameter status')
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when authenticated as customer' do
      before do
        active_product
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'returns status code forbidden' do
        patch "/api/v1/products/#{active_product.id}/status", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['messages']).to include('You are not allowed to edit product')
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        patch "/api/v1/products/#{active_product.id}/status", params: valid_attributes
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
