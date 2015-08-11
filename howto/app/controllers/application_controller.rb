class ApplicationController < ActionController::Base
 helper :all # include all helpers, all the time
  protect_from_forgery
  #filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :current_team, :getTime, :getDay

      private
        def current_user_session
          return @current_user_session if defined?(@current_user_session)
          @current_user_session = UserSession.find
        end

        def current_user
          return @current_user if defined?(@current_user)
          @current_user = current_user_session && current_user_session.user
        end
        
        def current_team
			if current_user
				current_user.equipe_id
			else
			   #4
			   #return cookies[:random_team] if (not cookies[:random_team].blank?)
			   if (cookies[:random_team].blank?)
				cookies[:random_team] = 1 + rand(128)
			   end
			   return cookies[:random_team]
			end	
		end
		
		def getTime
			time = Time.new
			#return time.strftime("%H:%M:%S")
			return time.to_i*1000
		end
		
		def getDay
			day =  Club.find_by_sql(["SELECT jour_courant from annees"]);
			return day[0].jour_courant
		end
		
		protected 
		def render_optional_error_file(status_code) 
			render :template => "errors/500", :status => 500, :layout => 'application' 
		end
end
