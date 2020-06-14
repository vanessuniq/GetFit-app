class TypesController < ApplicationController
    get '/users/:username/types' do
        if user_verified?
            @types = current_user.types.uniq
            @faillure = session.delete(:faillure)
            erb :'types/show_all'
        else
           redirect '/sessions/login' 
        end

    end

    get '/users/:username/types/:id' do
        if user_verified? 
            @type = find_type
            erb :'types/show'
        else
            redirect '/sessions/login'
        end
    end
end