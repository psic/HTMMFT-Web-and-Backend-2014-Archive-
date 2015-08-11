class CreateContrats < ActiveRecord::Migration
  def self.up
    create_table :contrats do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :contrats
  end
end
