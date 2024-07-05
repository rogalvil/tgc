# frozen_string_literal: true

# User serializer
class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :name, :role
end
