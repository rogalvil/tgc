# frozen_string_literal: true

# UserPolicy class
class UserPolicy < ApplicationPolicy
  ERROR_MESSAGES = {
    update?: 'You are not allowed to update this user',
    show?: 'You are not allowed to view this user\'s information'
  }.freeze

  def show?
    user.admin? || record.customer?
  end

  relation_scope do |relation|
    next relation if user.admin?

    relation.where(role: 'customer')
  end

  private

  def owner?
    record == user
  end
end
