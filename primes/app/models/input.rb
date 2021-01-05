class Input < ApplicationRecord
  # model association
  belongs_to :system

  # validation
  validates_presence_of :input, :validInput
end
