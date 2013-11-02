# coding: utf-8

# チェックリストに登録されるアイテム
class ListItem < ActiveRecord::Base
  belongs_to :check_list
  belongs_to :product
  attr_accessible :checked, :comment, :image_path

  scope :with_products, joins('inner join products on list_items.product_id = products.id')
  # コンテンツに関する情報列のみ抜き出す。
  scope :select_contents_info, select('
    list_items.comment,
    list_items.image_path,
    list_items.checked,
    products.category,
    products.creater_name,
    products.item_url,
    products.title,
    products.publisher,
    products.release_date'
  )

  # 新しいアイテムをリストい追加
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

  # プロダクト情報を付加した状態でロードする。
  def self.find_with_products(check_list_id, only_unchecked = true, offset = 0, limit = 20)
    params = { :check_list_id => check_list_id }
    if only_unchecked
      params[:checked] = false
    end
    ListItem.where(params).with_products.select_contents_info.limit(limit).offset(offset)
  end
end
