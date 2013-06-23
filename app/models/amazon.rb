# coding: utf-8

require 'amazon/ecs'

# Amazon Prodcut Advertising API のラッパー
module Amazon
  module API

    # item_search API でのデフォルト最大取得件数
    DEFAULT_MAX_RESPONSE = 10

    @@ecs_options = {
      :associate_tag => Avan::Application.config.api_tokens["amazon"]["associate_tag"],
      :AWS_access_key_id => Avan::Application.config.api_tokens["amazon"]["access_key"],
      :AWS_secret_key => Avan::Application.config.api_tokens["amazon"]["secret_key"],
      :country => 'jp',
      :response_group => 'ItemAttributes,Images'
    }

    # item_search API をコール
    def self.search_items query, ecs_options = {}, max = DEFAULT_MAX_RESPONSE
      merged_opionts = @@ecs_options.merge ecs_options
      ecs_items = Amazon::Ecs.item_search(query, merged_opionts).items

      # Product オブジェクトに変換
      products = []
      ecs_items.each do |item|
        p = Product.from_ecs_response item
        if p != nil
          products.push p
        end
        if products.size >= max
          break
        end
      end
      return products
    end

    # item_lookup API をコール
    def self.lookup_items item_ids, ecs_options = {}
      unless item_ids.is_a? Array
        item_ids = [item_ids]
      end
      merged_opionts = @@ecs_options.merge ecs_options
      Amazon::Ecs.item_lookup item_ids.join(','), merged_opionts
    end

    # 音楽関連アイテムを取得する。
    def self.search_music_items query, ecs_options = {}, max = DEFAULT_MAX_RESPONSE
      merged_opionts = ecs_options.merge({ :search_index => 'Music' })
      self.search_items query, merged_opionts, max
    end
  end
end
