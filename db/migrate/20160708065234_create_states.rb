class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.string :status
      t.text :info
      t.string :url
      t.references :commodity, foreign_key: true

      t.timestamps
    end
  end
end
