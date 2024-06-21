# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:product) { build_stubbed(:product) }
  let(:context) { { user: } }

  describe_rule :index? do
    succeed 'when user is an admin' do
      before { user.role = 'admin' }
    end

    succeed 'when user is a customer' do
      before { user.role = 'customer' }
    end

    succeed 'when user is a guest' do
      before { user = Guest.new }
    end
  end

  describe_rule :show? do
    succeed 'when user is an admin' do
      before { user.role = 'admin' }
    end

    succeed 'when user is a customer' do
      before { user.role = 'customer' }
    end

    succeed 'when user is a guest' do
      before { user = Guest.new }
    end
  end

  describe_rule :create? do
    succeed 'when user is an admin' do
      before { user.role = 'admin' }
    end

    failed 'when user is a customer' do
      before { user.role = 'customer' }
    end

    failed 'when user is a guest' do
      before { user = Guest.new }
    end
  end

  describe_rule :update? do
    succeed 'when user is an admin' do
      before { user.role = 'admin' }
    end

    failed 'when user is a customer' do
      before { user.role = 'customer' }
    end

    failed 'when user is a guest' do
      before { user = Guest.new }
    end
  end

  describe_rule :destroy? do
    succeed 'when user is an admin' do
      before { user.role = 'admin' }
    end

    failed 'when user is a customer' do
      before { user.role = 'customer' }
    end

    failed 'when user is a guest' do
      before { user = Guest.new }
    end
  end

  describe_rule :update_stock? do
    succeed 'when user is an admin' do
      before { user.role = 'admin' }
    end

    failed 'when user is a customer' do
      before { user.role = 'customer' }
    end

    failed 'when user is a guest' do
      before { user = Guest.new }
    end
  end

  describe_rule :update_status? do
    succeed 'when user is an admin' do
      before { user.role = 'admin' }
    end

    failed 'when user is a customer' do
      before { user.role = 'customer' }
    end

    failed 'when user is a guest' do
      before { user = Guest.new }
    end
  end
end
