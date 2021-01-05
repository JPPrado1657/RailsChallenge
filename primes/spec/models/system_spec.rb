require 'rails_helper'

RSpec.describe System, type: :model do
  # Association test
  # Ensure System model has a 1:N relationship with the Input model
  it { should have_many(:inputs).dependent(:destroy) }
  
  # Validation tests
  # Ensure columns presence
  it { should validate_presence_of(:name) }
end
