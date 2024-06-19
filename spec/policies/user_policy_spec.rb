# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:user) }
  let(:context) { { user: } }

  describe_rule :show? do
    succeed 'when customer viewing another customer'

    succeed 'when customer is viewing themselves' do
      before { user = record }
    end

    failed 'when customer viewing an admin' do
      before { record.role = 'admin' }
    end

    succeed 'when admin viewing customer' do
      before { user.role = 'admin' }
      succeed 'when admin viewing another admin' do
        before { record.role = 'admin' }
      end
    end

    succeed 'when guest viewing customer' do
      before { user = Guest.new }
      failed 'when guest viewing an admin' do
        before do
          record.role = 'admin'
        end
      end
    end
  end

  describe_rule :update? do
    failed 'when user is not the owner or admin' do
      before do
        user.role = 'customer'
        record.role = 'customer'
      end
    end
    succeed 'when user is an admin' do
      before do
        user.role = 'admin'
      end
    end
    context 'Owner' do
      let!(:user) { record }
      succeed 'when is customer updating themselves'
      succeed 'when is admin updating themselves' do
        before { user.role = 'admin' }
      end
    end
  end
end
