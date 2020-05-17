require 'pry'
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
                redirect "/challenges/#{@challenge.id}"
            else
                @errors = @challenge.errors.full_messages
                erb :'challenges/create'
            end
            
        else
          redirect '/session/login'  
        end
    end

    get '/challenges/:id' do
        
        if logged_in?
            @challenges = Challenge.where(user: current_user) 
            @challenge = @challenges.select {|challenge| challenge.id = params[:id]}.first
            erb :'challenges/show'
        else
            redirect '/session/login'
        end
    end

    get '/challenges/:id/edit' do
        if logged_in?
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

    
end