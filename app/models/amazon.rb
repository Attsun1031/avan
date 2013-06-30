# coding: utf-8

require 'amazon/ecs'

# Amazon Prodcut Advertising API のラッパー
module Amazon
  module API

    # amazon api 関連のパラメータ
    @@ecs_options = {
      :associate_tag => Avan::Application.config.api_tokens["amazon"]["associate_tag"],
      :AWS_access_key_id => Avan::Application.config.api_tokens["amazon"]["access_key"],
      :AWS_secret_key => Avan::Application.config.api_tokens["amazon"]["secret_key"],
      :country => 'jp',
      :response_group => 'ItemAttributes,Images',
      :item_page => 1
    }

    # item_search API をコール
    def self.search_items query, ecs_options = {}
      merged_opionts = @@ecs_options.merge ecs_options
      ecs_response = Amazon::Ecs.item_search(query, merged_opionts)
      ApiResult.new ecs_response
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
    def self.search_music_items query, ecs_options = {}
      merged_opionts = ecs_options.merge({ :search_index => 'Music' })
      self.search_items query, merged_opionts
    end
  end


  # API の結果を保持するオブジェクト
  # アイテム情報は Product オブジェクトとして保持される。
  class ApiResult
    attr_reader :error, :current_page, :total_pages, :total_results, :products

    def initialize ecs_response
      @is_valid_request = ecs_response.is_valid_request?
      @has_error = ecs_response.has_error?
      @error = ecs_response.error
      @total_pages = ecs_response.total_pages
      @total_results = ecs_response.total_results
      @current_page = ecs_response.item_page
      @products = convert2products ecs_response.items
    end

    def is_valid_request?
      return @is_valid_request
    end

    def has_error?
      return @has_error
    end

    protected

    # API から取得したオブジェクトを Product に変換する。
    def convert2products ecs_items
      products = []
      ecs_items.each do |item|
        p = EcsResponseConverter.convert item
        if p != nil and p.valid?
          products.push p
        end
      end
      return products
    end
  end


  # API からのレスポンスを Product オブジェクトに変換する。
  module EcsResponseConverter
    def self.convert ecs_item
      category = ecs_item.get "ItemAttributes/Binding"
      if not @@category_converter_map.include? category
        return nil
      end
      converter = @@category_converter_map[category]
      return converter.convert ecs_item
    end

    # 変換基底クラス
    class EcsResponseConverterBase

      # API から取得したアイテムから Product を生成する。
      def convert ecs_item
        product = Product.new
        product.asin = ecs_item.get "ASIN"
        product.category = ecs_item.get "ItemAttributes/Binding"
        product.image_url = ecs_item.get "SmallImage/URL"
        product.publisher = ecs_item.get "ItemAttributes/Publisher"
        product.title = ecs_item.get "ItemAttributes/Title"
        product.item_url = ecs_item.get "DetailPageURL"
        do_convert product, ecs_item
        return product
      end

      protected
      # convert における、サブクラスでの固有実装
      def do_convert product, ecs_item
      end
    end

    # CD アイテムのコンバーター
    class EcsResponseCDConverter < EcsResponseConverterBase
      def do_convert product, ecs_item
        product.creater_name = ecs_item.get "ItemAttributes/Artist"
      end
    end

    # DVD アイテムのコンバーター
    class EcsResponseDVDConverter < EcsResponseConverterBase
      def do_convert product, ecs_item
        product.creater_name = ecs_item.get "ItemAttributes/Actor"
      end
    end

    # アイテム種別ごとのコンバーターオブジェクトマップ
    @@category_converter_map = {
      "CD" => EcsResponseCDConverter.new,
      "DVD" => EcsResponseDVDConverter.new
    }
  end
end
