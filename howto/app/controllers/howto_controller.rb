class HowtoController < ApplicationController
	layout "report"
  def index
    if not current_user
	@user_session = UserSession.new
	end
  end

end
