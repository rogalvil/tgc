# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user, :customer) }
  let(:guest) { create(:user, :guest) }
  let(:users) { create_list(:user, 3) }

  describe 'GET /index' do
    context 'when authenticated as admin' do
      before do
        users
        customer
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'returns a list of all users' do
        get '/api/v1/users', headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        users.each do |user|
          expect(json['data'].any? { |u| u['id'].to_i == user.id }).to be_truthy
        end
        expect(json['data'].any? { |u| u['id'].to_i == customer.id }).to be_truthy
        expect(json['data'].any? { |u| u['id'].to_i == admin.id }).to be_truthy
        expect(json['data'].size).to eq(users.size + 2)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as customer' do
      before do
        users
        admin
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'returns a list of customers only' do
        get '/api/v1/users', headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        users.each do |user|
          expect(json['data'].any? { |u| u['id'].to_i == user.id }).to be_truthy
        end
        expect(json['data'].any? { |u| u['id'].to_i == customer.id }).to be_truthy
        expect(json['data'].any? { |u| u['id'].to_i == admin.id }).to be_falsey
        expect(json['data'].size).to eq(users.size + 1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        get '/api/v1/users'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /show' do
    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'returns the admin user' do
        get "/api/v1/users/#{admin.id}", headers: { 'Authorization': @auth_token }
        expect(json['data']['id'].to_i).to eq(admin.id)
        expect(response).to have_http_status(:ok)
      end

      it 'returns a customer user' do
        get "/api/v1/users/#{customer.id}", headers: { 'Authorization': @auth_token }
        expect(json['data']['id'].to_i).to eq(customer.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'returns the customer user' do
        get "/api/v1/users/#{customer.id}", headers: { 'Authorization': @auth_token }
        expect(json['data']['id'].to_i).to eq(customer.id)
        expect(response).to have_http_status(:ok)
      end

      it 'returns status code 404 for an admin user' do
        get "/api/v1/users/#{admin.id}", headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      it 'returns the customer user' do
        get "/api/v1/users/#{customer.id}"
        expect(json['data']['id'].to_i).to eq(customer.id)
        expect(response).to have_http_status(:ok)
      end

      it 'returns status code 404 for an admin user' do
        get "/api/v1/users/#{admin.id}", headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT /update' do
    let(:valid_attributes) { { user: { name: 'New Name' } } }

    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'updates the admin user' do
        put "/api/v1/users/#{admin.id}", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['name']).to eq('New Name')
        expect(response).to have_http_status(:ok)
      end

      it 'updates a customer user' do
        put "/api/v1/users/#{customer.id}", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['name']).to eq('New Name')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'updates the customer user' do
        put "/api/v1/users/#{customer.id}", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['name']).to eq('New Name')
        expect(response).to have_http_status(:ok)
      end

      it 'returns status code 404 for updating an admin user' do
        put "/api/v1/users/#{admin.id}", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns status code 403 for updating another customer user' do
        other_customer = create(:user, :customer)
        put "/api/v1/users/#{other_customer.id}", params: valid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        put "/api/v1/users/#{customer.id}", params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
