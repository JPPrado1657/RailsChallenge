require 'rails_helper'

RSpec.describe Input, type: :model do
  # Association test
  # Ensure Input model belongs to System model
  it { should belong_to(:system) }
  
  # Validation tests
  # Ensure columns presence
  it { should validate_presence_of(:input) }
  it { should validate_presence_of(:validInput) }
end
