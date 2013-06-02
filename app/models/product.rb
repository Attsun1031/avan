class Product < ActiveRecord::Base
  attr_accessible :asin, :attribute, :category, :creater_name, :image_path, :publisher, :title
end
