# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:product) { build_stubbed(:product) }
  let(:context) { { user: } }

  describe_rule :index? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer' do
      before { user.role = 'customer' }
      succeed 'allows access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      succeed 'allows access'
    end
  end

  describe_rule :show? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer' do
      before { user.role = 'customer' }
      succeed 'allows access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      succeed 'allows access'
    end
  end

  describe_rule :create? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer' do
      before { user.role = 'customer' }
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

    context 'when customer' do
      before { user.role = 'customer' }
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

    context 'when customer' do
      before { user.role = 'customer' }
      failed 'denies access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      failed 'denies access'
    end
  end

  describe_rule :update_stock? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer' do
      before { user.role = 'customer' }
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

    context 'when customer' do
      before { user.role = 'customer' }
      failed 'denies access'
    end

    context 'when guest' do
      before { user.role = 'guest' }
      failed 'denies access'
    end
  end
end
