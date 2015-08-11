class JoueursController < ApplicationController
  # GET /joueurs
  # GET /joueurs.xml
  def index
    @joueurs = Joueur.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @joueurs }
    end
  end

  # GET /joueurs/1
  # GET /joueurs/1.xml
  def show
  #  @joueur = Joueur.find(params[:id])

	#@joueur = Joueur.find(params[:id], :include => [:contrats])
	 @joueur = Joueur.find(params[:id], :include => [:contrats, :equipes])
										

	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @joueur }
    end
  end

  # GET /joueurs/new
  # GET /joueurs/new.xml
  def new
    @joueur = Joueur.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @joueur }
    end
  end

  # GET /joueurs/1/edit
  def edit
    @joueur = Joueur.find(params[:id])
  end

  # POST /joueurs
  # POST /joueurs.xml
  def create
    @joueur = Joueur.new(params[:joueur])

    respond_to do |format|
      if @joueur.save
        flash[:notice] = 'Joueur was successfully created.'
        format.html { redirect_to(@joueur) }
        format.xml  { render :xml => @joueur, :status => :created, :location => @joueur }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @joueur.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /joueurs/1
  # PUT /joueurs/1.xml
  def update
    @joueur = Joueur.find(params[:id])

    respond_to do |format|
      if @joueur.update_attributes(params[:joueur])
        flash[:notice] = 'Joueur was successfully updated.'
        format.html { redirect_to(@joueur) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @joueur.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /joueurs/1
  # DELETE /joueurs/1.xml
  def destroy
    @joueur = Joueur.find(params[:id])
    @joueur.destroy

    respond_to do |format|
      format.html { redirect_to(joueurs_url) }
      format.xml  { head :ok }
    end
  end
end
