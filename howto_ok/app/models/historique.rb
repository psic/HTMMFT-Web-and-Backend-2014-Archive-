class Historique < ActiveRecord::Base
belongs_to :saison
belongs_to :equipe
has_many :classements
end
