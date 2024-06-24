# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:user) }
  let(:context) { { user: } }
  let(:other_customer) { build_stubbed(:user) }
  let(:other_admin) { build_stubbed(:user, :admin) }

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
      context 'viewing customer' do
        succeed 'allows access'
      end
      context 'viewing another admin' do
        before { record.role = 'admin'}
        succeed 'allows access'
      end
      context 'viewing themselves' do
        before { record.id = user.id }
        succeed 'allows access'
      end
    end

    context 'when customer' do
      context 'viewing other customer' do
        succeed 'allows access'
      end
      context 'viewing admin' do
        before { record.role = 'admin' }
        failed 'denies access'
      end
      context 'viewing themselves' do
        before { record.id = user.id }
        succeed 'allows access'
      end
    end

    context 'when guest' do
      before { user.role = 'guest' }
      context 'viewing customer' do
        succeed 'allows access'
      end
      context 'viewing admin' do
        before { record.role = 'admin' }
        failed 'denies access'
      end
    end
  end

  describe_rule :update? do
    context 'when admin' do
      before { user.role = 'admin' }
      context 'updating customer' do
        succeed 'allows access'
      end
    end
    context 'when customer' do
      context 'updating another customer' do
        failed 'denies access'
      end
      context 'updating admin' do
        before { record.role = 'admin' }
        failed 'denies access'
      end
      context 'updating themselves' do
        before { record.id = user.id }
        succeed 'allows access'
      end
    end

    context 'when guest' do
      before { user.role = 'guest' }
      context 'updating customer' do
        failed 'denies access'
      end
      context 'updating admin' do
        before { record.role = 'admin' }
        failed 'denies access'
      end
    end
  end
end
