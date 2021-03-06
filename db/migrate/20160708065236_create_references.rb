class CreateReferences < ActiveRecord::Migration[5.0]
  def change
    create_table :references do |t|
      t.string :kind
      t.integer :source_commodity_id
      t.integer :target_commodity_id
      t.text :description
      t.integer :visibility, default: 0
      t.references :app, foreign_key: true
      t.references :commodity_reference, foreign_key: true

      t.timestamps
    end
  end
end
