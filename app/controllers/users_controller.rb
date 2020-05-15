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

    

end