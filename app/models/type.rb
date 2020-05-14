class Type < ActiveRecord::Base
    has_many :challenges
    has_many :users, through: :challenges
end