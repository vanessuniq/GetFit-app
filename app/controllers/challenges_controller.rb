require 'pry'
class ChallengesController < ApplicationController
    
    get '/users/:username/challenges' do
        if user_verified?
            @challenges = current_user.challenges
            @message = session.delete(:success)
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
            @challenge.set_end_date(@challenge.start_date, params[:challenge][:duration])
            @challenge.type = Type.find(params[:type])

            @challenge.create_days(params[:challenge][:duration], params[:reps], params[:rep_increment])
            
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
            @challenge = find_challenge
            @message = session.delete(:success)
            erb :'challenges/show'
        else
            redirect '/sessions/login'
        end
    end

    get '/users/:username/challenges/:id/edit' do
        if user_verified?

            
            @challenge = find_challenge

            @types = Type.all
            @errors = session.delete(:errors)
            erb :'/challenges/update'
        else
            redirect '/sessions/login'
        end
    end

    patch '/challenges/:id' do
        @challenge = find_challenge
        @challenge.set_end_date(@challenge.start_date, params[:challenge][:duration])
        @challenge.duration = params[:challenge][:duration]
        @challenge.sets = params[:challenge][:sets]
        @challenge.days.destroy_all

        @challenge.create_days(params[:challenge][:duration], params[:reps], params[:rep_increment])

        
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
            @challenge = find_challenge
            @challenge.days.destroy_all
            @challenge.destroy
            session[:success] = "Your challenge has been successfully deleted"
            
            redirect "/users/#{params[:username]}/challenges"
        else
            redirect '/sessions/login'
        end
    end

end
