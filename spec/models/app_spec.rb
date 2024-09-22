require 'rails_helper'

RSpec.describe App, type: :model do
  it { should validate_presence_of(:name) }
end
