# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :request do
  let(:admin) { create(:user, role: 'admin') }
  let(:customer) { create(:user, role: 'customer') }
  let(:other_customer) { create(:user, role: 'customer') }
  let(:guest) { create(:user, role: 'guest') }
  let(:order) { create(:order, user: customer) }
  let(:other_order) { create(:order) }
  let(:all_orders) { [order, other_order] }

  describe 'GET /api/v1/orders' do
    context 'when authenticated as admin' do
      before do
        all_orders
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'returns all orders' do
        get '/api/v1/orders', headers: { 'Authorization': @auth_token }
        all_orders.each do |order|
          expect(json['data'].any? { |o| o['id'].to_i == order.id }).to be_truthy
        end
        expect(json['data'].size).to eq(all_orders.size)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as customer' do
      before do
        all_orders
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'returns only customer orders' do
        get '/api/v1/orders', headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        expect(json['data'].any? { |o| o['id'].to_i == order.id }).to be_truthy
        expect(json['data'].any? { |o| o['id'].to_i == other_order.id }).to be_falsey
        expect(json['data'].size).to eq(customer.orders.count)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        get '/api/v1/orders'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/orders/:id' do
    context 'when authenticated as admin' do
      before do
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'returns the order' do
        get "/api/v1/orders/#{order.id}", headers: { 'Authorization': @auth_token }
        expect(json['data']['id'].to_i).to eq(order.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as customer and owner' do
      before do
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'returns the order' do
        get "/api/v1/orders/#{order.id}", headers: { 'Authorization': @auth_token }
        expect(json['data']['id'].to_i).to eq(order.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as another customer' do
      before do
        @auth_token = login_with_api(email: other_customer.email, password: other_customer.password)
      end

      it 'returns not found' do
        get "/api/v1/orders/#{order.id}", headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        get "/api/v1/orders/#{order.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/orders' do
    context 'when authenticated as customer' do
      before do
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'creates an order' do
        post '/api/v1/orders', headers: { 'Authorization': @auth_token }
        expect(json['data']['relationships']['user']['data']['id'].to_i).to eq(customer.id)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when authenticated as admin' do
      before do
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'returns forbidden' do
        post '/api/v1/orders', headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        post '/api/v1/orders'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/orders/:id' do
    context 'when authenticated as admin' do
      before do
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'deletes the order' do
        delete "/api/v1/orders/#{order.id}", headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:no_content)
        expect(Order.exists?(order.id)).to be_falsey
      end
    end

    context 'when authenticated as customer and owner' do
      before do
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'deletes the order if pending' do
        order.update(status: 'pending')
        delete "/api/v1/orders/#{order.id}", headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:no_content)
        expect(Order.exists?(order.id)).to be_falsey
      end

      it 'returns forbidden if not pending' do
        order.update(status: 'paid')
        delete "/api/v1/orders/#{order.id}", headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authenticated as another customer' do
      before do
        @auth_token = login_with_api(email: other_customer.email, password: other_customer.password)
      end

      it 'returns not found' do
        delete "/api/v1/orders/#{order.id}", headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        delete "/api/v1/orders/#{order.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/orders/:id/status' do
    let(:valid_status) { { order: { status: 'paid' } } }
    let(:invalid_status) { { order: { status: '' } } }

    context 'when authenticated as admin' do
      before do
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'updates the order status' do
        patch "/api/v1/orders/#{order.id}/status", params: valid_status, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:ok)
        expect(order.reload.status).to eq('paid')
      end

      it 'returns 422 with invalid status' do
        patch "/api/v1/orders/#{order.id}/status", params: invalid_status, headers: { 'Authorization': @auth_token }
        expect(json['messages']).to include("Status can't be blank")
        expect(json['messages']).to include('Status is not included in the list')
        expect(response).to have_http_status(422)
      end
    end

    context 'when authenticated as customer and owner' do
      before do
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'updates the order status' do
        patch "/api/v1/orders/#{order.id}/status", params: valid_status, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:ok)
        expect(order.reload.status).to eq('paid')
      end

      it 'returns 422 with invalid status' do
        patch "/api/v1/orders/#{order.id}/status", params: invalid_status, headers: { 'Authorization': @auth_token }
        expect(json['messages']).to include("Status can't be blank")
        expect(json['messages']).to include('Status is not included in the list')
        expect(response).to have_http_status(422)
      end
    end

    context 'when authenticated as another customer' do
      before do
        @auth_token = login_with_api(email: other_customer.email, password: other_customer.password)
      end

      it 'returns not found' do
        patch "/api/v1/orders/#{order.id}/status", params: valid_status, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        patch "/api/v1/orders/#{order.id}/status", params: valid_status
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
