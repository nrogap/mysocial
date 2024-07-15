require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:user).required }
  end

  describe 'validations' do
    it { should validate_presence_of(:message) }
    it { should validate_length_of(:message).is_at_least(3) }
  end
end
