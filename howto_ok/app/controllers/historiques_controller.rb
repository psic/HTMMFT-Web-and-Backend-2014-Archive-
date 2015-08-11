class HistoriquesController < ApplicationController
  # GET /historiques
  # GET /historiques.xml
  def index
    @historiques = Historique.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @historiques }
    end
  end

  # GET /historiques/1
  # GET /historiques/1.xml
  def show
    @historique = Historique.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @historique }
    end
  end

  # GET /historiques/new
  # GET /historiques/new.xml
  def new
    @historique = Historique.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @historique }
    end
  end

  # GET /historiques/1/edit
  def edit
    @historique = Historique.find(params[:id])
  end

  # POST /historiques
  # POST /historiques.xml
  def create
    @historique = Historique.new(params[:historique])

    respond_to do |format|
      if @historique.save
        flash[:notice] = 'Historique was successfully created.'
        format.html { redirect_to(@historique) }
        format.xml  { render :xml => @historique, :status => :created, :location => @historique }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @historique.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /historiques/1
  # PUT /historiques/1.xml
  def update
    @historique = Historique.find(params[:id])

    respond_to do |format|
      if @historique.update_attributes(params[:historique])
        flash[:notice] = 'Historique was successfully updated.'
        format.html { redirect_to(@historique) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @historique.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /historiques/1
  # DELETE /historiques/1.xml
  def destroy
    @historique = Historique.find(params[:id])
    @historique.destroy

    respond_to do |format|
      format.html { redirect_to(historiques_url) }
      format.xml  { head :ok }
    end
  end
end
