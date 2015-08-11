class UserSessionsController < ApplicationController
  
  def new
    @user_session = UserSession.new
  end
  def create
  
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Connecte."
     # redirect_to root_url
     redirect_to "/mon_equipe"
    else
      render :action => 'new'
    end
  end
  def destroy
  #  @user_session = UserSession.find(params[:id])
 #  @user_session.destroy
     current_user_session.destroy
    flash[:notice] = "Deconnecte."
    redirect_to "/"
    #redirect_to index_user_url
  end
end
