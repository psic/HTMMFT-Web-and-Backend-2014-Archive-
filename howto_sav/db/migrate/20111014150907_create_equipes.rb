class CreateEquipes < ActiveRecord::Migration
  def self.up
    create_table :equipes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :equipes
  end
end
