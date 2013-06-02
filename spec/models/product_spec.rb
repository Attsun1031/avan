# coding: utf-8

require 'spec_helper'
require 'amazon'

describe Product do
  describe 'find_by_ids' do
    it 'should find one item by amazon api' do
      products = Product.find_by_ids 'B00065MDRW'
      products.items.length.should == 1
      product = products.items[0]
      product.title.should == 'In the Court of the Crimson King'
      product.creater_name.should == 'King Crimson'
      product.publisher.should == 'Discipline Us'
      product.image_path.should == 'http://ecx.images-amazon.com/images/I/61FTYY6ZP3L._SL75_.jpg'
    end
  end
end
