class UsersController < ApplicationController

    get '/users' do
        redirect '/'
    end

    get '/registration/signup' do
        if logged_in?
            redirect "/users/#{current_user.username}"
        else
            @errors = session.delete(:errors)
            erb :'users/signup'
        end
    end

    post '/registration' do
        @user = User.new(params)
        if @user.save
            session[:user_id] = @user.id
            redirect "/users/#{current_user.username}"
        else
            session[:errors] = @user.errors.full_messages
            redirect '/registration/signup'
        end
    end

    get '/users/:username' do
        if logged_in?
            @user = current_user
            erb :'users/profile'
        else
            redirect '/sessions/login'
        end
    end

    get '/sessions/login' do
        if logged_in?
            redirect "/users/#{current_user.username}" 
        else
            @errors = session.delete(:errors)
            erb :'users/login'
        end
    end

    post '/sessions' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect "/users/#{current_user.username}"
        else
            session[:errors] = "Invalid username or password"
            redirect '/sessions/login'
        end
    end

    get '/sessions/logout' do
        session.clear
        redirect '/'
    end

end