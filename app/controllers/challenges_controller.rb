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
            @challenge = current_user.challenges.build(params[:challenge])
            @challenge.type = Type.find(params[:type])
            @challenge.build_challenge_days
            
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
            @challenge = current_user.selected_challenge
            #@message = session.delete(:success) add it to show.erb
            erb :'challenges/show'
        else
            redirect '/sessions/login'
        end
    end

    get 'users/:username/challenges/:id/edit' do
        if user_verified? #START HERE
            @challenge = current_user.challenges.select {|challenge| challenge.id = params[:id]}.first
            @types = Type.all
            @errors = session.delete(:errors)
            erb :'/challenges/update'
        else
            redirect '/sessions/login'
        end
    end

    patch '/challenges/:id' do
        @challenge = current_user.selected_challenge
        if @challenge.update(params[:challenge])
            #@challenge.days.clear

            @challenge.type = Type.find(params[:type])
            @challenge.days.each {|day| day.destroy}

            @challenge.build_challenge_days
            @challenge.save
            #add success message (session[:success] = "challenge successfully updated")
            redirect "/users/#{@challenge.user.username}/challenges/#{@challenge.id}"
        else
            session[:errors] = @challenge.errors.full_messages
            redirect "users/#{@challenge.user.username}/challenges/#{@challenge.id}/edit"
        end
    end

    delete '/users/:username/challenges/:id' do
        if user_verified?
            @challenge = current_user.challenges.select {|challenge| challenge.id = params[:id]}.first
            @challenge.destroy
            
            redirect "/users/#{params[:username]}/challenges"
        else
            redirect '/sessions/login'
        end
    end

    
end