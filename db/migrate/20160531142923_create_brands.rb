class CreateBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :brands do |t|
      t.string :name
      t.boolean :official, default: false
      t.string :logo
      t.string :description
      t.references :app, foreign_key: true

      t.timestamps
    end
  end
end