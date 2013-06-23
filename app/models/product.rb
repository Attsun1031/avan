# coding: utf-8

class Product < ActiveRecord::Base
  attr_accessible :asin, :category, :creater_name, :image_url, :item_attributes, :item_url, :publisher, :title

  # TODO: Binding = DVD に対応する。(DVD では "Artist" がとれない）
  # ecs のキー名と、それに対応する Product オブジェクトのフィールド名のマップ
  @@ECS_KEY_FIELD_NAME_MAP = {
    "ASIN" => { :field_name => :asin },
    "ItemAttributes/Binding" => { :field_name => :category },
    "ItemAttributes/Artist" => { :field_name => :creater_name },
    "SmallImage/URL" => { :field_name => :image_url, :nullable => true },
    "ItemAttributes/Publisher" => { :field_name => :publisher },
    "ItemAttributes/Title" => { :field_name => :title },
    "DetailPageURL" => { :field_name => :item_url }
  }

  # ecs のレスポンスからオブジェクトを生成する。
  def self.from_ecs_response ecs_response
    product = Product.new
    @@ECS_KEY_FIELD_NAME_MAP.each do |ecs_key, ecs_attr_infos|
      ecs_value = ecs_response.get(ecs_key)
      if not ecs_attr_infos.fetch :nullable, false and ecs_value.blank?
        return nil
      end
      product[ecs_attr_infos[:field_name]] = ecs_value
    end
    return product
  end
end
