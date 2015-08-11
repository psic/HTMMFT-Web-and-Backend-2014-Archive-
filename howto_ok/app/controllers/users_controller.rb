class UsersController < ApplicationController
  def index
  
  end
  
  def new
    @user = User.new
 #   @equipes_array = Equipe.find(:all,:include => [:saisons => :historiques] ,:joins => [[:saisons => :historiques], [:saisons => :division]])
	@equipes_array = Equipe.find_by_sql('SELECT equipes.nom as equipe, equipes.id as id, divisions.nom as division FROM equipes, divisions, saisons, historiques WHERE
										equipes.id = historiques.equipe_id AND historiques.saison_id = saisons.id
										AND divisions.id = saisons.division_id').map{|equipe| [equipe.division + ' / ' + equipe.equipe , equipe.id ]}
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Utilisateur cree avec succes."
      redirect_to '/'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
 def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
     flash[:notice] = "Utilisateur mis a jour avec succes."
      redirect_to @user
    else
      render :action => 'edit'
    end
 end
 def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Utilisateur detruit avec succes."
    redirect_to users_url
  end
end
