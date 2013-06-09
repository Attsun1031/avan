class ListItem < ActiveRecord::Base
  belongs_to :check_list
  belongs_to :product
  attr_accessible :checked, :comment, :image_path
end
