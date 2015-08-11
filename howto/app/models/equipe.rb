class Equipe < ActiveRecord::Base
has_many :contrats
has_many :joueurs, :through => :contrats
has_many :historiques
has_many :saisons, :through => :historiques
belongs_to :club
end
