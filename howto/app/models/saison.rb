class Saison < ActiveRecord::Base
has_many :historiques
has_many :equipes, :through => :historiques
belongs_to :division
has_many :matchs
end
