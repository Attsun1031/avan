# coding: utf-8

require 'amazon/ecs'

# API wrapper for Amazon Prodcut Advertising API
module Amazon
  module API
    @@options = {
      :associate_tag => Avan::Application.config.api_tokens["amazon"]["associate_tag"],
      :AWS_access_key_id => Avan::Application.config.api_tokens["amazon"]["access_key"],
      :AWS_secret_key => Avan::Application.config.api_tokens["amazon"]["secret_key"],
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
