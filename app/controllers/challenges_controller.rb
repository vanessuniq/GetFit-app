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

            # set variables to build days
            @total_days = (params[:challenge][:duration]).to_i
            @num_reps = (params[:reps]).to_i
            @rep_increment = (params[:rep_increment]).to_i
            @counter = 1
                                                        #is there a way to abstract this 2
            # build challenge days
            @total_days.times do
                @challenge.days.build(name: "day#{@counter}", reps: @num_reps)
                @counter += 1
                @num_reps += @rep_increment
            end
            
            if @challenge.save
                session[:success] = "Your #{@challenge.duration}-day #{@challenge.name} challenge has been successfully created."
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
            @challenge = current_user.challenges.find(params[:id])
            @message = session.delete(:success)
            erb :'challenges/show'
        else
            redirect '/sessions/login'
        end
    end

    get '/users/:username/challenges/:id/edit' do
        if user_verified?
            @challenge = current_user.challenges.find(params[:id])
            @types = Type.all
            @errors = session.delete(:errors)
            erb :'/challenges/update'
        else
            redirect '/sessions/login'
        end
    end

    patch '/challenges/:id' do
        @challenge = current_user.challenges.find(params[:id])
        @challenge.duration = params[:challenge][:duration]
        @challenge.sets = params[:challenge][:sets]
        @challenge.days.destroy_all

        # set variables to build days
        @total_days = (params[:challenge][:duration]).to_i
        @num_reps = (params[:reps]).to_i
        @rep_increment = (params[:rep_increment]).to_i
        @counter = 1
        
        # build challenge days
        @total_days.times do
            @challenge.days.build(name: "day#{@counter}", reps: @num_reps)
            @counter += 1
            @num_reps += @rep_increment
        end
        if @challenge.save
            session[:success] = "Your #{@challenge.name} challenge has been successfully updated."
            redirect "/users/#{@challenge.user.username}/challenges/#{@challenge.id}"
        else
            session[:errors] = @challenge.errors.full_messages
            redirect "users/#{@challenge.user.username}/challenges/#{@challenge.id}/edit"
        end
    end

    delete '/users/:username/challenges/:id' do
        if user_verified?
            @challenge = current_user.challenges.select {|challenge| challenge.id = params[:id]}.first
            @challenge.days.destroy_all
            @challenge.destroy
            
            redirect "/users/#{params[:username]}/challenges"
        else
            redirect '/sessions/login'
        end
    end

    
end