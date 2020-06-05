class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :views, Proc.new { File.join(root, "../views/") }
    set :public_dir, "public"

    configure do
        enable :sessions
        set :session_secret, "uniquely_bold"
    end

    get '/' do
        erb :index
    end

    helpers do
        def logged_in?
          !!session[:user_id]
        end
    
        def current_user
          User.find(session[:user_id])
        end

        def user_verified?
          logged_in? && current_user.username == params[:username]
        end

        def find_challenge
          challenge = current_user.challenges.find_by(id: params[:id])
          if challenge
              challenge
          else
              session[:faillure] = "There's no such challenge in your list. Please select a challenge below or create a new challenge."
              redirect "/users/#{current_user.username}/challenges"  
          end
        end

        def find_type
          type = current_user.types.find_by(id: params[:id])
          if type
              type
          else
              session[:faillure] = "There's no such type in your list, please select a type below."
              redirect "/users/#{current_user.username}/types"  
          end
        end

    end
end