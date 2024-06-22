# frozen_string_literal: true

# OrderPolicy class
class OrderPolicy < ApplicationPolicy
  ERROR_MESSAGES = {
    edit?: 'You are not allowed to edit order',
    read?: 'You are not allowed to view order'
  }.freeze

  alias_rule :update_status?, to: :edit?

  def read?
    admin? || owner?
  end

  def create?
    owner?
  end

  relation_scope do |scope|
    if admin?
      scope.all
    else
      scope.where(user_id: user.id)
    end
  end
end
