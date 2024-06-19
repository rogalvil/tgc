# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:user) }
  let(:context) { { user: } }

  describe_rule :show? do
    succeed 'when customer is viewing themselves' do
      before { user = record }
    end

    succeed 'when customer viewing another customer' do
      before do
        user.role = 'customer'
        record.role = 'customer'
      end
    end

    failed 'when customer viewing an admin' do
      before do
        user.role = 'customer'
        record.role = 'admin'
      end
    end

    succeed 'when admin viewing customer' do
      before { user.role = 'admin' }
    end

    succeed 'when admin viewing another admin' do
      before do
        user.role = 'admin'
        record.role = 'admin'
      end
    end

    succeed 'when guest viewing customer' do
      before { user = Guest.new }
    end

    failed 'when guest viewing an admin' do
      before do
        user = Guest.new
        record.role = 'admin'
      end
    end
  end


end
