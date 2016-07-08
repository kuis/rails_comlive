class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :member, :polymorphic => true
end
