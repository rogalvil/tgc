# frozen_string_literal: true

# Model for guest users only for devise authentication and action policy purposes
class Guest
  def id
    nil
  end

  def guest?
    true
  end

  def customer?
    false
  end

  def admin?
    false
  end
end
