# coding: utf-8

require 'auth_infos'

# API for Amazon Prodcut Advertising API
module AmazonProductAdvertisingAPI
  module API
    class APIBase
      def self.send_request request
      end
    end

    class ItemSearchAPI < APIBase
      def self.search_item query, response_groups, browse_node = ''
        # build request object
        # validate request
        # send request
        # build response object
      end

      def self.search_cd query, response_groups
        self.search_item query, response_groups, Request::BROWSE_NODE_MAP[:cd]
      end
    end
  end

  module Request
    RESPONSE_GROUPS = Set.new [
      "ItemAttributes",
      "Images",
      "OfferSummary",
    ]

    BROWSE_NODE_MAP = {
      :cd => '561956'
    }

    class RequestBase
      def initialize params
        @params = params
      end

      def build_request_url
      end
    end

    class ItemSearchAPIRequest < RequestBase
    end
  end

  module Response
    class ResponseBase
    end

    class ItemSearchAPIResponse < ResponseBase
    end
  end
end
