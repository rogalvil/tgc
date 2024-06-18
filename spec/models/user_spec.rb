require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_invalid_name) { build :user, :with_invalid_name }
  let(:admin_user) { build :user, :admin }
  let(:customer_user) { build :user }
  subject(:user) { build :user }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  describe 'validations' do
    it 'is invalid for name' do
      expect(user_invalid_name).to_not be_valid
    end
  end

  describe '#admin?' do
    context 'when user is an admin' do
      it 'returns true' do
        expect(admin_user.admin?).to be_truthy
      end
    end

    context 'when user is not an admin' do
      it 'returns false' do
        expect(customer_user.admin?).to be_falsey
      end
    end
  end
end
