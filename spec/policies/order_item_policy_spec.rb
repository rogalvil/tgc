# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItemPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:order) { build_stubbed(:order, user:) }
  let(:record) { build_stubbed(:order_item, order:) }
  let(:context) { { user: } }
  let(:other_customer) { build_stubbed(:user) }

  describe_rule :index? do
    context 'when admin' do
      before { user.role = 'admin' }
      succeed 'allows access'
    end

    context 'when customer' do
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

    context 'when customer is the owner of the order' do
      before { record.order.user = user }
      succeed 'allows access'
    end

    context 'when customer but not the owner of the order' do
      before { record.order.user = other_customer }
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
      context 'but order' do
        context 'is pending' do
          before { record.order.status = 'pending' }
          succeed 'allows access'
        end
        context 'is paid' do
          before { record.order.status = 'paid' }
          failed 'denies access'
        end
        context 'is shipped' do
          before { record.order.status = 'shipped' }
          failed 'denies access'
        end
        context 'is delivered' do
          before { record.order.status = 'delivered' }
          failed 'denies access'
        end
        context 'is cancelled' do
          before { record.order.status = 'cancelled' }
          failed 'denies access'
        end
      end
    end

    context 'when customer' do
      context 'is the owner' do
        before { record.order.user = user }
        context 'but order' do
          context 'is pending' do
            before { record.order.status = 'pending' }
            succeed 'allows access'
          end
          context 'is paid' do
            before { record.order.status = 'paid' }
            failed 'denies access'
          end
          context 'is shipped' do
            before { record.order.status = 'shipped' }
            failed 'denies access'
          end
          context 'is delivered' do
            before { record.order.status = 'delivered' }
            failed 'denies access'
          end
          context 'is cancelled' do
            before { record.order.status = 'cancelled' }
            failed 'denies access'
          end
        end
      end
      context 'but not is the owner' do
        before { record.order.user = other_customer }
        context 'and order' do
          context 'is pending' do
            before { record.order.status = 'pending' }
            succeed 'allows access'
          end
          context 'is paid' do
            before { record.order.status = 'paid' }
            failed 'denies access'
          end
          context 'is shipped' do
            before { record.order.status = 'shipped' }
            failed 'denies access'
          end
          context 'is delivered' do
            before { record.order.status = 'delivered' }
            failed 'denies access'
          end
          context 'is cancelled' do
            before { record.order.status = 'cancelled' }
            failed 'denies access'
          end
        end
      end
    end
  end

  describe_rule :update? do
    context 'when admin' do
      before { user.role = 'admin' }
      context 'but order' do
        context 'is pending' do
          before { record.order.status = 'pending' }
          succeed 'allows access'
        end
        context 'is paid' do
          before { record.order.status = 'paid' }
          failed 'denies access'
        end
        context 'is shipped' do
          before { record.order.status = 'shipped' }
          failed 'denies access'
        end
        context 'is delivered' do
          before { record.order.status = 'delivered' }
          failed 'denies access'
        end
        context 'is cancelled' do
          before { record.order.status = 'cancelled' }
          failed 'denies access'
        end
      end
    end

    context 'when customer' do
      context 'is the owner' do
        before { record.order.user = user }
        context 'but order' do
          context 'is pending' do
            before { record.order.status = 'pending' }
            succeed 'allows access'
          end
          context 'is paid' do
            before { record.order.status = 'paid' }
            failed 'denies access'
          end
          context 'is shipped' do
            before { record.order.status = 'shipped' }
            failed 'denies access'
          end
          context 'is delivered' do
            before { record.order.status = 'delivered' }
            failed 'denies access'
          end
          context 'is cancelled' do
            before { record.order.status = 'cancelled' }
            failed 'denies access'
          end
        end
      end
      context 'but not is the owner' do
        before { record.order.user = other_customer }
        context 'and order' do
          context 'is pending' do
            before { record.order.status = 'pending' }
            succeed 'allows access'
          end
          context 'is paid' do
            before { record.order.status = 'paid' }
            failed 'denies access'
          end
          context 'is shipped' do
            before { record.order.status = 'shipped' }
            failed 'denies access'
          end
          context 'is delivered' do
            before { record.order.status = 'delivered' }
            failed 'denies access'
          end
          context 'is cancelled' do
            before { record.order.status = 'cancelled' }
            failed 'denies access'
          end
        end
      end
    end
  end

  describe_rule :destroy? do
    context 'when admin' do
      before { user.role = 'admin' }
      context 'but order' do
        context 'is pending' do
          before { record.order.status = 'pending' }
          succeed 'allows access'
        end
        context 'is paid' do
          before { record.order.status = 'paid' }
          failed 'denies access'
        end
        context 'is shipped' do
          before { record.order.status = 'shipped' }
          failed 'denies access'
        end
        context 'is delivered' do
          before { record.order.status = 'delivered' }
          failed 'denies access'
        end
        context 'is cancelled' do
          before { record.order.status = 'cancelled' }
          failed 'denies access'
        end
      end
    end

    context 'when customer' do
      context 'is the owner' do
        before { record.order.user = user }
        context 'but order' do
          context 'is pending' do
            before { record.order.status = 'pending' }
            succeed 'allows access'
          end
          context 'is paid' do
            before { record.order.status = 'paid' }
            failed 'denies access'
          end
          context 'is shipped' do
            before { record.order.status = 'shipped' }
            failed 'denies access'
          end
          context 'is delivered' do
            before { record.order.status = 'delivered' }
            failed 'denies access'
          end
          context 'is cancelled' do
            before { record.order.status = 'cancelled' }
            failed 'denies access'
          end
        end
      end
      context 'but not is the owner' do
        before { record.order.user = other_customer }
        context 'and order' do
          context 'is pending' do
            before { record.order.status = 'pending' }
            succeed 'allows access'
          end
          context 'is paid' do
            before { record.order.status = 'paid' }
            failed 'denies access'
          end
          context 'is shipped' do
            before { record.order.status = 'shipped' }
            failed 'denies access'
          end
          context 'is delivered' do
            before { record.order.status = 'delivered' }
            failed 'denies access'
          end
          context 'is cancelled' do
            before { record.order.status = 'cancelled' }
            failed 'denies access'
          end
        end
      end
    end
  end
end
