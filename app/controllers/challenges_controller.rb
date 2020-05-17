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

            @challenge = current_user.challenges.build(params[:challenge])
            @type = Type.find(params[:type])
            @challenge.type = @type 
            n.times do
                c = 1
                @challenge.days << Day.new(name: "day#{c}", sets: num_sets)
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
end