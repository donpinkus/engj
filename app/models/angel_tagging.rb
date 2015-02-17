class AngelTagging < ActiveRecord::Base
  belongs_to :angel_tag
  belongs_to :angel_taggable, :polymorphic => true
end
