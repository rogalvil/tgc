# frozen_string_literal: true

# UserPolicy class
class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def customers?
    true
  end

  def show?
    user.admin? || record.customer?
  end
end
