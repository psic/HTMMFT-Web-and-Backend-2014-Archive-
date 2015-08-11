# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "annees", :force => true do |t|
    t.integer "annee_courante",                :null => false
    t.integer "mois_courant",                  :null => false
    t.integer "jour_courant",                  :null => false
    t.integer "journee",        :default => 0, :null => false
  end

  create_table "classements", :force => true do |t|
    t.integer "points",        :default => 0, :null => false
    t.integer "victoire",      :default => 0, :null => false
    t.integer "defaite",       :default => 0, :null => false
    t.integer "nul",           :default => 0, :null => false
    t.integer "bp",            :default => 0, :null => false
    t.integer "bc",            :default => 0, :null => false
    t.integer "ext_victoire",  :default => 0, :null => false
    t.integer "ext_defaite",   :default => 0, :null => false
    t.integer "ext_nul",       :default => 0, :null => false
    t.integer "ext_points",    :default => 0, :null => false
    t.integer "ext_bp",        :default => 0, :null => false
    t.integer "ext_bc",        :default => 0, :null => false
    t.integer "dom_victoire",  :default => 0, :null => false
    t.integer "dom_defaite",   :default => 0, :null => false
    t.integer "dom_nul",       :default => 0, :null => false
    t.integer "dom_points",    :default => 0, :null => false
    t.integer "dom_bp",        :default => 0, :null => false
    t.integer "dom_bc",        :default => 0, :null => false
    t.integer "historique_id",                :null => false
    t.integer "nb_journee",    :default => 0, :null => false
  end

  create_table "clubs", :force => true do |t|
    t.string  "president",           :limit => 50,  :null => false
    t.integer "couleur1",                           :null => false
    t.integer "couleur2",                           :null => false
    t.string  "stade",               :limit => 100, :null => false
    t.integer "capacite_stade",                     :null => false
    t.integer "argent",                             :null => false
    t.integer "centre_de_formation",                :null => false
  end

  create_table "contrats", :force => true do |t|
    t.integer "anne_debut", :null => false
    t.integer "mois_debut", :null => false
    t.integer "duree",      :null => false
    t.integer "anne_fin",   :null => false
    t.integer "mois_fin",   :null => false
    t.integer "salaire",    :null => false
    t.integer "equipe_id",  :null => false
    t.integer "joueur_id",  :null => false
  end

  create_table "divisions", :force => true do |t|
    t.string "nom", :limit => 25, :null => false
  end

  create_table "equipes", :force => true do |t|
    t.string  "nom",     :limit => 50, :null => false
    t.integer "club_id",               :null => false
  end

  create_table "feuilles_de_matchs", :force => true do |t|
    t.integer "stats_j1_id"
    t.integer "stats_j2_id"
    t.integer "stats_j3_id"
    t.integer "stats_j4_id"
    t.integer "stats_j5_id"
    t.integer "stats_j6_id"
    t.integer "stats_j7_id"
    t.integer "stats_j8_id"
    t.integer "stats_j9_id"
    t.integer "stats_j10_id"
    t.integer "stats_j11_id"
    t.integer "stats_j12_id"
    t.integer "stats_j13_id"
    t.integer "stats_j14_id"
    t.integer "stats_j15_id"
    t.integer "stats_j16_id"
  end

  create_table "historiques", :force => true do |t|
    t.integer "saison_id", :null => false
    t.integer "equipe_id", :null => false
  end

  create_table "joueurs", :force => true do |t|
    t.string  "nom",             :limit => 50,                  :null => false
    t.string  "prenom",          :limit => 50,                  :null => false
    t.integer "age",                                            :null => false
    t.integer "xp",                                             :null => false
    t.integer "talent",                                         :null => false
    t.integer "tactique",                                       :null => false
    t.integer "technique",                                      :null => false
    t.integer "physique",                                       :null => false
    t.integer "vitesse",                                        :null => false
    t.integer "mental",                                         :null => false
    t.integer "off",                                            :null => false
    t.integer "def",                                            :null => false
    t.integer "drt",                                            :null => false
    t.integer "ctr",                                            :null => false
    t.integer "gch",                                            :null => false
    t.boolean "liste_transfert",                                :null => false
    t.boolean "liste_pret",                                     :null => false
    t.integer "condition",                     :default => 100, :null => false
    t.integer "blessure",                      :default => 0,   :null => false
    t.integer "moral",                         :default => 100, :null => false
    t.integer "numero",                        :default => 0,   :null => false
  end

  create_table "matchs", :force => true do |t|
    t.integer "equipe1_id",       :null => false
    t.integer "equipe2_id",       :null => false
    t.integer "score1"
    t.integer "score2"
    t.integer "num_journee",      :null => false
    t.integer "saison_id",        :null => false
    t.integer "fdm_equipe1"
    t.integer "fdm_equipe2"
    t.integer "tactique_equipe1"
    t.integer "tactique_equipe2"
  end

  create_table "positions", :force => true do |t|
    t.integer "x"
    t.integer "y"
    t.integer "x1"
    t.integer "y1"
    t.integer "x2"
    t.integer "y2"
    t.integer "x3"
    t.integer "y3"
    t.integer "x4"
    t.integer "y4"
    t.integer "x5"
    t.integer "y5"
    t.integer "x6"
    t.integer "y6"
    t.integer "x7"
    t.integer "y7"
    t.integer "x8"
    t.integer "y8"
    t.integer "x9"
    t.integer "y9"
    t.integer "x10"
    t.integer "y10"
    t.integer "x11"
    t.integer "y11"
    t.integer "x12"
    t.integer "y12"
    t.integer "x+"
    t.integer "x-"
    t.integer "y+"
    t.integer "y-"
    t.boolean "offensif"
    t.boolean "defensif"
    t.integer "id_joueur"
  end

  create_table "saisons", :force => true do |t|
    t.integer "annee_id",    :null => false
    t.integer "division_id", :null => false
  end

  create_table "staff_contrats", :force => true do |t|
    t.integer "annee_debut", :null => false
    t.integer "mois_debut",  :null => false
    t.integer "duree",       :null => false
    t.integer "annee_fin",   :null => false
    t.integer "mois_fin",    :null => false
    t.integer "salaire",     :null => false
    t.integer "equipe_id",   :null => false
    t.integer "staff_id",    :null => false
    t.integer "poste",       :null => false
  end

  create_table "staffs", :force => true do |t|
    t.string  "nom",         :limit => 30,                  :null => false
    t.string  "prenom",      :limit => 30,                  :null => false
    t.integer "age",                                        :null => false
    t.integer "xP",                                         :null => false
    t.integer "talent",                                     :null => false
    t.integer "physique",                                   :null => false
    t.integer "technique",                                  :null => false
    t.integer "tactique",                                   :null => false
    t.integer "mental",                                     :null => false
    t.integer "medecine",                                   :null => false
    t.integer "recrutement",                                :null => false
    t.integer "off",                                        :null => false
    t.integer "def",                                        :null => false
    t.integer "moral",                     :default => 100, :null => false
  end

  create_table "stats", :force => true do |t|
    t.integer "ballon+"
    t.integer "ballon-"
    t.integer "passe+"
    t.integer "passe-"
    t.integer "tackle+"
    t.integer "tackle-"
    t.integer "tir+"
    t.integer "tir-"
    t.float "note"
    t.integer "but+"
    t.integer "drible-"
    t.integer "drible+"
    t.integer "id_joueur"
  end

  create_table "tactiques", :force => true do |t|
    t.integer "position_j1_id"
    t.integer "position_j2_id"
    t.integer "position_j3_id"
    t.integer "position_j4_id"
    t.integer "position_j5_id"
    t.integer "position_j6_id"
    t.integer "position_j7_id"
    t.integer "position_j8_id"
    t.integer "position_j9_id"
    t.integer "position_j10_id"
    t.integer "position_j11_id"
    t.integer "remplacant1_id"
    t.integer "remplacant2_id"
    t.integer "remplacant3_id"
    t.integer "remplacant4_id"
    t.integer "remplacant5_id"
  end

  create_table "users", :force => true do |t|
    t.string  "login",             :limit => 30, :null => false
    t.integer "equipe_id",                       :null => false
    t.string  "email",                           :null => false
    t.string  "crypted_password",                :null => false
    t.string  "password_salt",                   :null => false
    t.string  "persistence_token",               :null => false
    t.datetime "created_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.integer "login_count"
    t.string  "current_login_ip"
    t.string  "last_login_ip" 
  end
end
