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

    # call item_search API
    def self.search_items query, options = {}
      merged_opionts = @@options.merge options
      Amazon::Ecs.item_search query, merged_opionts
    end

    # call item_lookup API
    def self.lookup_items item_ids, options = {}
      unless item_ids.is_a? Array
        item_ids = [item_ids]
      end
      merged_opionts = @@options.merge options
      Amazon::Ecs.item_lookup item_ids.join(','), merged_opionts
    end

    # find items related to music
    def self.search_music_items query, options = {}
      merged_opionts = options.merge({ :search_index => 'Music' })
      self.search_items query, merged_opionts
    end
  end
end
