class ListItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  attr_accessible :checked, :comment
end
