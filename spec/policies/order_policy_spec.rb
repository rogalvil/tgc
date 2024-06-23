# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:order, user:) }
  let(:context) { { user: } }
  let(:other_customer) { build_stubbed(:user) }

  describe_rule :index? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer is the owner' do
      before { record.user = user }
      succeed 'allows access'
    end

    context 'when customer but not is the owner' do
      before { record.user = other_customer }
      succeed 'allows access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      failed 'denies access'
    end
  end

  describe_rule :show? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer is the owner' do
      before { record.user = user }
      succeed 'allows access'
    end

    context 'when customer but not is the owner' do
      before { record.user = other_customer }
      succeed 'allows access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      failed 'denies access'
    end
  end

  describe_rule :create? do
    context 'when admin' do
      before { user.role = 'admin' }
      failed 'allows access'
    end

    context 'when customer is the owner' do
      before { record.user = user }
      succeed 'allows access'
    end

    context 'when customer but not is the owner' do
      before { record.user = other_customer }
      failed 'denies access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      failed 'denies access'
    end
  end

  describe_rule :update? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer is the owner' do
      before { record.user = user }
      succeed 'allows access'
    end

    context 'when customer but not is the owner' do
      before { record.user = other_customer }
      failed 'denies access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      failed 'denies access'
    end
  end

  describe_rule :destroy? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer is the owner' do
      before { record.user = user }
      context 'status default' do
        succeed 'allows access'
      end
      context 'status pending' do
        before { record.status = 'pending' }
        succeed 'allows access'
      end
      context 'status paid' do
        before { record.status = 'paid' }
        failed 'denies access'
      end
      context 'status shipped' do
        before { record.status = 'shipped' }
        failed 'denies access'
      end
      context 'status delivered' do
        before { record.status = 'delivered' }
        failed 'denies access'
      end
      context 'status cancelled' do
        before { record.status = 'cancelled' }
        failed 'denies access'
      end
    end

    context 'when customer but not is the owner' do
      before { record.user = other_customer }
      failed 'denies access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      failed 'denies access'
    end
  end

  describe_rule :update_status? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer is the owner' do
      before { record.user = user }
      succeed 'allows access'
    end

    context 'when customer but not is the owner' do
      before { record.user = other_customer }
      failed 'denies access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      failed 'denies access'
    end
  end
end
