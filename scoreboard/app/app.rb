module Scoreboard
    class App < Padrino::Application
        register SassInitializer
        register Padrino::Rendering
        register Padrino::Mailer
        register Padrino::Helpers
        register Padrino::Admin::AccessControl
        register Padrino::Admin::Helpers

        enable :sessions
        set :session_id, "lol_this_is_my_session"
        set :protect_from_csrf, false

        set :server, 'thin'
        set :bind, '0.0.0.0'

        ##
        # Caching support.
        #
        # register Padrino::Cache
        # enable :caching
        #
        # You can customize caching store engines:
        #
        # set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
        # set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
        # set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
        # set :cache, Padrino::Cache::Store::Memory.new(50)
        # set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
        #

        ##
        # Application configuration options.
        #
        # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
        # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
        # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
        # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
        # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
        # set :reload, false            # Reload application files (default in development)
        # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
        # set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
        # disable :sessions             # Disabled sessions by default (enable if needed)
        # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
        # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
        #

        ##
        # You can configure for a specified environment like:
        #
        #   configure :development do
        #     set :foo, :bar
        #     disable :asset_stamp # no asset timestamping for dev
        #   end
        #

        ##
        # You can manage errors like:
        #
        #   error 404 do
        #     render 'errors/404'
        #   end
        #
        #   error 505 do
        #     render 'errors/505'
        #   end
        #
        layout :layout
        get "/" do 
            "hello world"
        end

        get "/home" do
            erb :home
        end

        get "/challenges" do
            if Account.current == nil
                redirect "/login"
            end
            @ch = Challenge.all
            erb :challenges
        end

        get "/register" do
            erb :register
        end

        get "/login" do
            redirect "/admin/sessions/new"
        end

        get "/logout" do
            Account.current = nil
            redirect "/home"
        end

        post '/challenges' do #submit a challenge
            if Account.current == nil
                redirect '/login'
            end
            chid = params["id"]
            flag = params["flag"]
            team = Account.current.name

            if chid.nil? or flag.nil? #if you submitted not enough, just redirect
                redirect '/challenges'
            end
            puts "ID = #{chid}"
            this_chall = Challenge.get(chid)
            if this_chall.nil? #if a challegne doesn't exit, just redirect
                puts "challenge was nil"
                redirect '/challenges'
            end

            puts "challenge = #{this_chall.title}"
            resp = Response.new #make a new response
            chall = this_chall.title
            resp.title = chall.to_s
            resp.challengeid = this_chall.id
            resp.team = team
            resp.flag = flag
            if resp.save
                puts "got response!"
            else
                redirect "/fail"
            end

            if this_chall.flag == flag #got it?
                has_check = Solve.all(:challengeid => chid).all(:team => team)
                puts has_check.count
                if has_check.count > 0 #if you've already solved it, this wont be nil
                    flash[:notice] = "you've already solved that one!"
                    redirect '/challenges'
                end
                bonus = 1
                count = Solve.all(:challengeid=> chid).count
                puts count
                got_it = Solve.new #hasn't been solved by you before, let's make a solve
                got_it.title = this_chall.title
                got_it.team = team
                got_it.challengeid = this_chall.id
                got_it.points = (this_chall.points * bonus).to_i
                if got_it.save
                    flash[:notice] = "Success!"
                    redirect '/challenges'
                else
                    redirect "/fail"
                end
            end
            flash[:notice] = escape("wow, you suck, try to get the actual flag next time, ok? *<;-)")
            redirect '/challenges'
        end

        get "/scores" do
            erb :scores
        end

        get '/scores/:team' do
            tName = Base64.decode64(params[:team])
            puts tName
            puts tName
            puts tName
            puts tName
            puts tName
            team = Account.first(:name => tName)
            @sol = Solve.all(:team => team.name)
            erb :teamscores
        end

        get '/scoreboard' do
            u = Account.all
            s = Solve.all
            h = Hash.new()
            u.each do |us|
                h[us.name] = 0
            end
            s.each do |sc|
                h[sc.team] += sc.points
            end
            @scoreboard = h.sort_by{|k,v| v}.reverse
            erb :scoreboard
        end

        get "/upload" do
            acc = Account.current
            if acc == nil
                redirect "/login"
            end
            if acc.role != "admin"
                redirect "/fail"
            else
                haml :upload
            end
        end

        # Handle POST-request (Receive and save the uploaded file)
        post "/upload" do
            puts "writing file!!!!"
            puts Dir.pwd
            puts Dir.pwd
            puts Dir.pwd
            puts Dir.pwd
            puts Dir.pwd
            acc = Account.current
            if acc == nil
                redirect "/login"
            end
            if acc.role != "admin"
                redirect "/fail"
            end
            File.open('public/challenges/' + params['myfile'][:filename], "wb") do |f|
                f.write(params['myfile'][:tempfile].read)
            end
            puts "WOWE"
            return "The file was successfully uploaded!"
        end

        get "/challenges/:file" do
            send_file(File.join('public/challenges/', params[:file]))
        end
    end
end
