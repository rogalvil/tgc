# frozen_string_literal: true

# UserPolicy class
class UserPolicy < ApplicationPolicy
  ERROR_MESSAGES = {
    update?: 'You are not allowed to update this user',
    show?: 'You are not allowed to view this user\'s information'
  }.freeze

  alias_rule :index?, :create?, :destroy?, to: :manage?
  alias_rule :show?, :update?, to: :edit?

  def manage?
    admin?
  end

  def edit?
    admin? || owner?
  end

  relation_scope do |relation|
    next relation if user.admin?

    relation.where(id: user.id)
  end

  private

  def owner?
    record == user
  end
end
