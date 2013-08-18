# coding: utf-8

class Product < ActiveRecord::Base
  attr_accessible :asin, :category, :creater_name, :image_url, :item_attributes, :item_url, :publisher, :release_date, :title

  validates :asin, :presence => true
  validates :category, :presence => true
  validates :creater_name, :presence => true
  validates :item_url, :presence => true
  validates :title, :presence => true
  validates :release_date, :presence => true
end
