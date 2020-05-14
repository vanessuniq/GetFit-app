class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :views, Proc.new { File.join(root, "../views/") }
    set :public_folder, 'public'

    configure do
        enable :sessions
        set :session_secret, "uniquely_bold"
    end

    get '/' do
        "We are doing it"
    end

    helpers do
        def logged_in?
          !!session[:user_id]
        end
    
        def current_user
          User.find(session[:user_id])
        end
    end
end