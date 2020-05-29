class User < ActiveRecord::Base
    validates_presence_of :username, :email
    validates_uniqueness_of :username
    has_secure_password
    has_many :challenges
    has_many :types, through: :challenges

end