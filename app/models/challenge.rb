class Challenge < ActiveRecord::Base
    belongs_to :user
    belongs_to :type
    has_many :days
end