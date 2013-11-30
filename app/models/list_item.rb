# coding: utf-8

# チェックリストに登録されるアイテム
class ListItem < ActiveRecord::Base
  belongs_to :check_list
  belongs_to :product
  attr_accessible :checked, :comment, :image_path

  scope :with_products, joins(:product)
  # コンテンツに関する情報列のみ抜き出す。
  scope :select_contents_info, select('
    list_items.id as id,
    list_items.comment as comment,
    list_items.image_path as image_path,
    list_items.checked as checked,
    products.category as category,
    products.creater_name as creater_name,
    products.item_url as item_url,
    products.title as title,
    products.publisher as publisher,
    products.release_date as release_date'
  )

  # 新しいアイテムをリストに追加
  def self.register(check_list_id, product_attr, comment)
    ListItem.transaction do
      # 未登録の product なら保存
      product = Product.find_by_asin(product_attr[:asin])
      if product == nil
        product = Product.new(product_attr)
        product.save!
      else
        # すでに登録済みのリストがあれば、フラグを更新して終了
        list = ListItem.find_by_check_list_id_and_product_id(check_list_id, product.id)
        if list != nil
          list.checked = false
          list.comment = comment
          list.save!
          return list
        end
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
    res = ListItem.where(params).with_products.select_contents_info.limit(limit + 1).offset(offset)
    has_more_item = res.length > limit
    return res[0, limit - 1], has_more_item
  end
end
