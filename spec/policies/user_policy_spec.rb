require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:admin_user) { build :user, :admin }
  let(:customer_user) { build :user }

  # permissions :index? do
  #   it 'grants access if user is an admin' do
  #     expect(subject).to permit(admin, User)
  #   end

  #   it 'denies access if user is not an admin' do
  #     expect(subject).not_to permit(customer, User)
  #   end
  # end

  # describe_rule :index? do
  #   context 'when user is an admin' do
  #     let(:user) { admin_user }

  #     it 'grants access' do
  #       expect(subject.apply(user, :index?)).to be_truthy
  #     end
  #   end

  #   context 'when user is not an admin' do
  #     let(:user) { customer_user }

  #     it 'denies access' do
  #       expect(subject.apply(user, :index?)).to be_falsey
  #     end
  #   end
  # end
  # describe_rule :index? do
  #   succeed 'allows access if user is an admin' do
  #     let(:user) { admin_user }
  #   end

  #   failed 'denies access if user is not an admin' do
  #     let(:user) { customer_user }
  #   end
  # end

  # describe_rule :customers? do
  #   succeed 'allows access to anyone' do
  #     let(:user) { admin_user }
  #   end

  #   succeed 'allows access to anyone' do
  #     let(:user) { customer_user }
  #   end
  # end
end
