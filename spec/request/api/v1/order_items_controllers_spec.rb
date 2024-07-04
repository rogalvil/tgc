# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :request do
  let(:admin) { create(:user, role: 'admin') }
  let(:customer) { create(:user, role: 'customer') }
  let(:other_customer) { create(:user, role: 'customer') }
  let(:guest) { create(:user, role: 'guest') }
  let(:order) { create(:order, user: customer) }
  let(:order_items) { create_list(:order_item, 3, order:) }
  let(:order_item) { order_items.first }
  let(:other_order_item) { create(:order_item) }
  let(:all_order_items) { [order_item, other_order_item] }
  let(:product) { create(:product) }

  describe 'GET /api/v1/orders/:order_id/items' do
    context 'when authenticated as customer' do
      before do
        order_items
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'retrieves all order items' do
        get "/api/v1/orders/#{order.id}/items",
            headers: { 'Authorization': @auth_token }
        expect(json['data'].size).to eq(3)
        expect(json['data'].map { |item| item['id'].to_i }).to match_array(order_items.pluck(:id))
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as admin' do
      before do
        order_items
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'retrieves all order items' do
        get "/api/v1/orders/#{order.id}/items",
            headers: { 'Authorization': @auth_token }
        expect(json['data'].size).to eq(3)
        expect(json['data'].map { |item| item['id'].to_i }).to match_array(order_items.pluck(:id))
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not authenticated' do
      it 'returns unauthorized' do
        get "/api/v1/orders/#{order.id}/items"
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated as another customer' do
      let(:another_customer) { create(:user, :customer) }
      before do
        @auth_token = login_with_api(email: another_customer.email, password: another_customer.password)
      end

      it 'returns not found' do
        get "/api/v1/orders/#{order.id}/items",
            headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /api/v1/orders/:order_id/items/:id' do
    context 'when authenticated as customer' do
      before do
        order_item
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'retrieves the order item' do
        get "/api/v1/orders/#{order.id}/items/#{order_item.id}",
            headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:ok)
        expect(json['data']['id'].to_i).to eq(order_item.id)
      end
    end

    context 'when authenticated as admin' do
      before do
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'retrieves the order item' do
        get "/api/v1/orders/#{order.id}/items/#{order_item.id}",
            headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:ok)
        expect(json['data']['id'].to_i).to eq(order_item.id)
      end
    end

    context 'when not authenticated' do
      it 'returns unauthorized' do
        get "/api/v1/orders/#{order.id}/items/#{order_item.id}"
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated as another customer' do
      let(:another_customer) { create(:user, :customer) }
      before do
        @auth_token = login_with_api(email: another_customer.email, password: another_customer.password)
      end

      it 'returns not found' do
        get "/api/v1/orders/#{order.id}/items/#{order_item.id}",
            headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/orders/:order_id/items' do
    let(:valid_params) { { order_item: { product_id: product.id, quantity: 2 } } }

    context 'when authenticated as customer and owner' do
      before do
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'creates an order item if order is pending' do
        order.update(status: 'pending')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(json['data']['relationships']['order']['data']['id'].to_i).to eq(order.id)
        expect(json['data']['relationships']['product']['data']['id'].to_i).to eq(product.id)
        expect(response).to have_http_status(:created)
      end

      it 'returns forbidden if order is paid' do
        order.update(status: 'paid')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is shipped' do
        order.update(status: 'shipped')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is delivered' do
        order.update(status: 'delivered')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is cancelled' do
        order.update(status: 'cancelled')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authenticated as admin' do
      before do
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'creates an order item if order is pending' do
        order.update(status: 'pending')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(json['data']['relationships']['order']['data']['id'].to_i).to eq(order.id)
        expect(json['data']['relationships']['product']['data']['id'].to_i).to eq(product.id)
        expect(response).to have_http_status(:created)
      end

      it 'returns forbidden if order is paid' do
        order.update(status: 'paid')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is shipped' do
        order.update(status: 'shipped')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is delivered' do
        order.update(status: 'delivered')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is cancelled' do
        order.update(status: 'cancelled')
        post "/api/v1/orders/#{order.id}/items",
             params: valid_params,
             headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        post "/api/v1/orders/#{order.id}/items", params: valid_params
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/orders/:order_id/items/:id' do
    let(:valid_params) { { order_item: { quantity: 5 } } }
    let(:invalid_params) { { order_item: { quantity: -1 } } }

    context 'when authenticated as customer and owner' do
      before do
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'updates the order item if order is pending' do
        order.update(status: 'pending')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:ok)
        expect(order_item.reload.quantity).to eq(5)
      end

      it 'returns forbidden if order is paid' do
        order.update(status: 'paid')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is shipped' do
        order.update(status: 'shipped')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is delivered' do
        order.update(status: 'delivered')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is cancelled' do
        order.update(status: 'cancelled')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns unprocessable content entity with invalid params' do
        order.update(status: 'pending')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: invalid_params,
              headers: { 'Authorization': @auth_token }
        expect(json['messages']).to include('Quantity must be greater than 0')
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context 'when authenticated as admin' do
      before do
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'updates the order item if order is pending' do
        order.update(status: 'pending')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:ok)
        expect(order_item.reload.quantity).to eq(5)
      end

      it 'returns forbidden if order is paid' do
        order.update(status: 'paid')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is shipped' do
        order.update(status: 'shipped')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is delivered' do
        order.update(status: 'delivered')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is cancelled' do
        order.update(status: 'cancelled')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns unprocessable content entity with invalid params' do
        order.update(status: 'pending')
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: invalid_params,
              headers: { 'Authorization': @auth_token }
        expect(json['messages']).to include('Quantity must be greater than 0')
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        patch "/api/v1/orders/#{order.id}/items/#{order_item.id}",
              params: valid_params
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/orders/:order_id/items/:id' do
    context 'when authenticated as customer and owner' do
      before do
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'deletes the order item if order is pending' do
        order.update(status: 'pending')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:no_content)
        expect(OrderItem.exists?(order_item.id)).to be_falsey
      end

      it 'returns forbidden if order is paid' do
        order.update(status: 'paid')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is shipped' do
        order.update(status: 'shipped')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is delivered' do
        order.update(status: 'delivered')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is cancelled' do
        order.update(status: 'cancelled')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authenticated as admin' do
      before do
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'deletes the order item if order is pending' do
        order.update(status: 'pending')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:no_content)
        expect(OrderItem.exists?(order_item.id)).to be_falsey
      end

      it 'returns forbidden if order is paid' do
        order.update(status: 'paid')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is shipped' do
        order.update(status: 'shipped')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is delivered' do
        order.update(status: 'delivered')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if order is cancelled' do
        order.update(status: 'cancelled')
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authenticated as another customer' do
      before do
        @auth_token = login_with_api(email: other_customer.email, password: other_customer.password)
      end

      it 'returns not found' do
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}",
               headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        delete "/api/v1/orders/#{order.id}/items/#{order_item.id}"
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
