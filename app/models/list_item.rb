# coding: utf-8

# チェックリストに存在する１アイテム
class ListItem < ActiveRecord::Base
  belongs_to :check_list
  belongs_to :product
  attr_accessible :checked, :comment, :image_path

  def self.register(check_list, product, comment)
    # 未登録の product なら保存
    unless Product.exists?(:asin => product.asin)
      product.save
    end

    list = self.new
    list.check_list_id = check_list.id
    list.product_id = product.id
    list.comment = comment
    list.image_path = product.image_url
    list.save
  end
end
