# frozen_string_literal: true

# ProductPolicy class
class ProductPolicy < ApplicationPolicy
  ERROR_MESSAGES = {
    edit?: 'You are not allowed to edit product',
    read?: 'You are not allowed to view product'
  }.freeze

  alias_rule :update_stock?, :update_status?, to: :edit?

  def edit?
    admin?
  end

  relation_scope do |relation|
    next relation if user.admin?

    relation.where(status: %w[active preorder])
  end
end
