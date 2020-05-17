class ChallengesController < ApplicationController
    get '/challenges' do
        @challenges = Challenge.all
        erb :'challenges/show_all'
    end

    get '/challenges/new' do
        if logged_in?
            @types = Type.all
            erb :'challenges/create'
        else
            redirect '/session/login'
        end
    end
end