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

    end
end