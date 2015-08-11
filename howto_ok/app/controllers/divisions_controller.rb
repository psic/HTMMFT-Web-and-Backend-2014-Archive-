class DivisionsController < ApplicationController
  def index
    @divisions = Division.all
  end

  def show
     @equipe = Equipe.find(:all, :include => [:saisons => :historiques],
				:conditions =>["saisons.division_id =?",params[:id]])
     @division = Division.find(params[:id])
    
  end
end
