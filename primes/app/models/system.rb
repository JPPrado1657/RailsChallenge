class System < ApplicationRecord
    # model association
    has_many :inputs, dependent: :destroy

    # validations
    validates_presence_of :name
end
