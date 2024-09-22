require 'rails_helper'

RSpec.describe Chat, type: :model do
  it  { should have_many(:message) }
end
