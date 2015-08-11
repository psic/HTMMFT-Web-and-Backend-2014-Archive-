class CreateHistoriques < ActiveRecord::Migration
  def self.up
    create_table :historiques do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :historiques
  end
end
