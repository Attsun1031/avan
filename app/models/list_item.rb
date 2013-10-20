# coding: utf-8

# チェックリストに存在するアイテム
class ListItem < ActiveRecord::Base
  belongs_to :check_list
  belongs_to :product
  attr_accessible :checked, :comment, :image_path

  def self.register(check_list_id, product_attr, comment)
    ListItem.transaction do
      # 未登録の product なら保存
      product = Product.find_by_asin(product_attr[:asin])
      if product == nil
        product = Product.new(product_attr)
        product.save!
      end

      list = self.new
      list.check_list_id = check_list_id
      list.product_id = product.id
      list.comment = comment
      list.image_path = product.image_url
      list.save!
      return list
    end
    # TODO: トランザクション失敗時の例外処理
  end
end
