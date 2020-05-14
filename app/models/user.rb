class User < ActiveRecord::Base
    validates_presence_of :username, :email
    has_secure_password
    has_many :challenges
    has_many :types, through: :challenges
end