class ClassementsController < ApplicationController
  def show
    @classement = Classement.find(params[:id])
  end
end
