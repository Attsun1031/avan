# coding: utf-8

require 'auth_infos'
require 'amazon/ecs'

# API wrapper for Amazon Prodcut Advertising API
module Amazon
  module API
    @@options = {
      :associate_tag => Auth::Amazon::ASSOSIATE_TAG,
      :AWS_access_key_id => Auth::Amazon::ACCESS_KEY,
      :AWS_secret_key => Auth::Amazon::SECRET_KEY,
      :country => 'jp',
      :response_group => 'ItemAttributes,Images'
    }

    def self.search_item query, options = {}
      merged_opionts = @@options.merge options
      Amazon::Ecs.item_search query, merged_opionts
    end

    def self.search_music query, options = {}
      merged_opionts = options.merge({ :search_index => 'Music' })
      self.search_item query, merged_opionts
    end
  end
end
