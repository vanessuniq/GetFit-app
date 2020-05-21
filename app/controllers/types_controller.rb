require 'pry'
class TypesController < ApplicationController
    get '/users/:username/types' do
        if user_verified?
            @types = current_user.types.uniq
            erb :'types/show_all'
        else
           redirect '/sessions/login' 
        end

    end

    get '/users/:username/types/:id' do
        if user_verified? 
            @type = current_user.types.select {|type| type.id = params[:id]}.first
            erb :'types/show'
        else
            redirect '/sessions/login'
        end
    end
end