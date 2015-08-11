class Joueur < ActiveRecord::Base
has_many :contrats
has_many :equipes, :through => :contrats
end
