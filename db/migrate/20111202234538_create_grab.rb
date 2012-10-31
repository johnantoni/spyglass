class CreateGrab < ActiveRecord::Migration
  def up
    create_table :grabs do |t|
      t.string :url
      t.string :file_type
      t.string :asset_path
    end
  end

  def down
  end
end
