class UsersController < ApplicationController
    
    get '/registration/signup' do
        if logged_in?
            redirect "/user/profile/#{current_user.username}"
        else
            erb :'users/signup'
        end
    end

    post '/registration' do
        @user = User.new(params)
        if @user.save
            session[:user_id] = @user.id
            redirect "/profile/#{current_user.username}"
        else
            @errors = @user.errors.full_messages
            redirect '/registration/signup'
        end
    end

    get '/session/login' do
        if logged_in?
            redirect "/profile/#{current_user.username}" 
        else
            erb :'users/login'
        end
    end

    post '/session' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect "/profile/#{current_user.username}"
        else
            @errors = "Invalid username or password"
            erb :'users/login'
        end
    end

    get '/session/logout' do
        session.clear
        redirect '/'
    end

    get '/profile/:username' do
        if logged_in?
            @user = current_user
            erb :'users/profile'
        else
            redirect '/session/login'
        end
    end

end