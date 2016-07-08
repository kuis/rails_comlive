class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      # t.string :type -- commented out as it conflicts with rails `type`
      t.references :user, foreign_key: true
      t.references :member, :polymorphic => true

      t.timestamps
    end
  end
end
