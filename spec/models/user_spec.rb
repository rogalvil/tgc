require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_invalid) { build :user, :with_invalid_name }
  subject(:user) { build :user }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  describe 'validations' do
    it 'throws an error when the name has numbers and characters' do
      expect(user_invalid).to_not be_valid
    end
  end
end
