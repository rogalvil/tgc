# frozen_string_literal: true

# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
  alias_rule :show?, :index?, to: :read?
  alias_rule :create?, :update?, :destroy?, to: :edit?

  def read?
    true
  end

  def edit?
    admin? || owner?
  end

  private

  def guest?
    user.guest?
  end

  def admin?
    user.admin?
  end

  def owner?
    record.user_id == user.id
  end
end
