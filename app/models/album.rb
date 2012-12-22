class Album < ActiveRecord::Base
  attr_accessible :artist, :asin, :category, :image_path, :name, :publisher, :release_date, :review, :tracks
end
