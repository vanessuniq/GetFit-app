class TypesController < ApplicationController
    get '/types' do
        if logged_in?
            @types = current_user.types
            erb :'types/show_all'
        else
           redirect '/session/login' 
        end

    end

    get '/types/:id' do
        if logged_in? 
            @type = current_user.types.select {|type| type.id = params[:id]}.first
            erb :'types/show'
        else
            redirect '/session/login'
        end
    end
end