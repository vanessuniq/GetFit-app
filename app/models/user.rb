class User < ActiveRecord::Base
    validates_presence_of :username, :email
    has_secure_password
    has_many :challenges
    has_many :types, through: :challenges

    def selected_challenge
        self.challenges.select {|challenge| challenge.id = params[:id]}.first
    end
end