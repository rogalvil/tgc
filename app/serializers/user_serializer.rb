# frozen_string_literal: true

# User serializer
class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :created_at
end
