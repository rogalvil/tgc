# frozen_string_literal: true

# OrderItemPolicy class
class OrderItemPolicy < ApplicationPolicy
  ERROR_MESSAGES = {
    edit?: 'You are not allowed to edit item',
    read?: 'You are not allowed to view item'
  }.freeze

  def read?
    admin? || owner?
  end

  def destroy?
    (admin? || owner?) && record.order.pending?
  end

  relation_scope do |scope|
    if admin?
      scope.all
    else
      scope.joins(:order).where(orders: { user_id: user.id })
    end
  end

  private

  def owner?
    user.id == record.order.user_id
  end
end
