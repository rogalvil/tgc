# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user, :customer) }
  let(:guest) { create(:user, :guest) }
  let(:users) { create_list(:user, 3) }

  describe 'GET /api/v1/users' do
    context 'when authenticated as admin' do
      before do
        users
        @auth_token = login_with_api(email: admin.email, password: admin.password)
      end

      it 'returns a list of all users' do
        get '/api/v1/users', headers: { 'Authorization': @auth_token }
        expect(json).not_to be_empty
        users.each do |user|
          expect(json['data'].any? { |u| u['id'].to_i == user.id }).to be_truthy
        end
        expect(json['data'].any? { |u| u['id'].to_i == admin.id }).to be_truthy
        expect(json['data'].size).to eq(users.size + 1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as customer' do
      before do
        @auth_token = login_with_api(email: customer.email, password: customer.password)
      end

      it 'returns status code forbidden' do
        get '/api/v1/users', headers: { 'Authorization': @auth_token }
        expect(json['messages']).to include('You are not allowed to perform this action')
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code unauthorized' do
        get '/api/v1/users'
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/users/:id' do
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
        expect(json['messages']).to include('Record not found')
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      it 'returns status code unauthorized for a customer' do
        get "/api/v1/users/#{customer.id}"
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns status code unauthorized for an admin user' do
        get "/api/v1/users/#{admin.id}", headers: { 'Authorization': @auth_token }
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/users' do
    let(:customer_valid_attributes) { { user: { email: 'newuser@example.com', password: 'password', name: 'New User' } } }
    let(:admin_valid_attributes_admin) { { user: { email: 'newadmin@example.com', password: 'password', name: 'New Admin', role: 'admin' } } }
    let(:invalid_attributes) { { user: { email: 'random', password: 'password', name: 'New User' } } }

    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'creates a new admin' do
        post '/api/v1/users', params: admin_valid_attributes_admin, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['email']).to eq('newadmin@example.com')
        expect(json['data']['attributes']['name']).to eq('New Admin')
        expect(json['data']['attributes']['role']).to eq('admin')
        expect(response).to have_http_status(:created)
      end

      it 'creates a new customer' do
        post '/api/v1/users', params: customer_valid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['email']).to eq('newuser@example.com')
        expect(json['data']['attributes']['name']).to eq('New User')
        expect(json['data']['attributes']['role']).to eq('customer')
        expect(response).to have_http_status(:created)
      end

      it 'returns status code unprocessable for invalid attributes' do
        post '/api/v1/users', params: invalid_attributes, headers: { 'Authorization': @auth_token }
        expect(json['messages']).to include('Email is invalid')
        expect(response).to have_http_status(422)
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'returns status code forbidden' do
        post '/api/v1/users', params: customer_valid_attributes, headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code unauthorized' do
        post '/api/v1/users', params: customer_valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/users/:id' do
    let(:valid_attributes) { { user: { name: 'New Name' } } }

    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'updates the admin user' do
        patch "/api/v1/users/#{admin.id}",
              params: valid_attributes,
              headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['name']).to eq('New Name')
        expect(response).to have_http_status(:ok)
      end

      it 'updates a customer user' do
        patch "/api/v1/users/#{customer.id}",
              params: valid_attributes,
              headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['name']).to eq('New Name')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'updates themselves' do
        patch "/api/v1/users/#{customer.id}",
              params: valid_attributes,
              headers: { 'Authorization': @auth_token }
        expect(json['data']['attributes']['name']).to eq('New Name')
        expect(response).to have_http_status(:ok)
      end

      it 'returns status code not found for updating an admin user' do
        patch "/api/v1/users/#{admin.id}",
              params: valid_attributes,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns status code not found for updating another customer user' do
        other_customer = create(:user, :customer)
        patch "/api/v1/users/#{other_customer.id}",
              params: valid_attributes,
              headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      it 'returns status code unauthorized' do
        patch "/api/v1/users/#{customer.id}", params: valid_attributes
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    context 'when authenticated as admin' do
      before { @auth_token = login_with_api(email: admin.email, password: admin.password) }

      it 'deletes the user' do
        delete "/api/v1/users/#{customer.id}", headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when authenticated as customer' do
      before { @auth_token = login_with_api(email: customer.email, password: customer.password) }

      it 'returns status code 403' do
        delete "/api/v1/users/#{customer.id}", headers: { 'Authorization': @auth_token }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when not authenticated' do
      it 'returns status code 401' do
        delete "/api/v1/users/#{customer.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
