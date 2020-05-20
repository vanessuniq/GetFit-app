require 'pry'
class ChallengesController < ApplicationController
    get '/users/:username/challenges' do
        if user_verified?
            @challenges = current_user.challenges
            erb :'challenges/show_all' 
        else
           redirect '/sessions/login' 
        end
        
    end

    get '/users/:username/challenges/new' do
        if user_verified?
            @types = Type.all
            @errors = session.delete(:errors)
            erb :'challenges/create'
        else
            redirect '/sessions/login'
        end
    end

    post '/challenges' do
        if logged_in?
            n = (params[:challenge][:duration]).to_i
            num_sets = (params[:sets]).to_i
            up = (params[:set_increment]).to_i
            c = 1

            @challenge = current_user.challenges.build(params[:challenge])
            @type = Type.find(params[:type])
            @challenge.type = @type 
            n.times do
                @challenge.days.build(name: "day#{c}", sets: num_sets)
                c += 1
                num_sets += up
            end
            if @challenge.save
                redirect "/users/#{current_user.username}/challenges/#{@challenge.id}"
            else
                session[:errors] = @challenge.errors.full_messages
                redirect "/users/#{current_user.username}/challenges/new"
            end
            
        else
          redirect '/sessions/login'  
        end
    end

    get '/users/:username/challenges/:id' do
        
        if user_verified?
            @challenge = current_user.challenges.select {|challenge| challenge.id = params[:id]}.first
            erb :'challenges/show'
        else
            redirect '/sessions/login'
        end
    end

    get '/challenges/:id/edit' do
        if logged_in? #START HERE
            @challenges = Challenge.where(user: current_user)
            @challenge = @challenges.select {|challenge| challenge.id = params[:id]}.first
            @types = Type.all
            erb :'/challenges/update'
        else
            redirect '/session/login'
        end
    end

    patch '/challenges/:id' do
        @challenges = Challenge.where(user: current_user)
        @challenge = @challenges.select {|challenge| challenge.id = params[:id]}.first
        if @challenge.update(params[:challenge])
            @challenge.days.clear

            @type = Type.find(params[:type])
            @challenge.type = @type
            @challenge.days.each {|day| day.destroy}

            n = (params[:challenge][:duration]).to_i
            num_sets = (params[:sets]).to_i
            up = (params[:set_increment]).to_i
            c = 1
            n.times do
                @challenge.days.build(name: "day#{c}", sets: num_sets)
                c += 1
                num_sets += up
            end
            @challenge.save
            redirect "/challenges/#{@challenge.id}"
        else
            @errors = @challenge.errors.full_messages
            erb :'challenges/update'
        end
    end

    delete '/challenges/:id/delete' do
        if logged_in?
            @challenges = Challenge.where(user: current_user)
            @challenge = @challenges.select {|challenge| challenge.id = params[:id]}.first
            @challenge.destroy
            
            redirect '/challenges'
        else
            redirect '/session/login'
        end
    end

    
end