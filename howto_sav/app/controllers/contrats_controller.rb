class ContratsController < ApplicationController
  # GET /contrats
  # GET /contrats.xml
  def index
    @contrats = Contrat.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contrats }
    end
  end

  # GET /contrats/1
  # GET /contrats/1.xml
  def show
    @contrat = Contrat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contrat }
    end
  end

  # GET /contrats/new
  # GET /contrats/new.xml
  def new
    @contrat = Contrat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contrat }
    end
  end

  # GET /contrats/1/edit
  def edit
    @contrat = Contrat.find(params[:id])
  end

  # POST /contrats
  # POST /contrats.xml
  def create
    @contrat = Contrat.new(params[:contrat])

    respond_to do |format|
      if @contrat.save
        flash[:notice] = 'Contrat was successfully created.'
        format.html { redirect_to(@contrat) }
        format.xml  { render :xml => @contrat, :status => :created, :location => @contrat }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contrat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contrats/1
  # PUT /contrats/1.xml
  def update
    @contrat = Contrat.find(params[:id])

    respond_to do |format|
      if @contrat.update_attributes(params[:contrat])
        flash[:notice] = 'Contrat was successfully updated.'
        format.html { redirect_to(@contrat) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contrat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contrats/1
  # DELETE /contrats/1.xml
  def destroy
    @contrat = Contrat.find(params[:id])
    @contrat.destroy

    respond_to do |format|
      format.html { redirect_to(contrats_url) }
      format.xml  { head :ok }
    end
  end
end
