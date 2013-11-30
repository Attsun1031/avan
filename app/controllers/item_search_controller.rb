# coding: utf-8

require 'amazon'

# 検索画面コントローラー
class ItemSearchController < ApplicationController
  def index
    @check_lists = CheckList.where(:user_id => session[:login_user_id]).order('id asc')
  end

  # アイテムの検索
  def search
    # TODO: エラーのときも json で返す
    item_search_params = ItemSearchParams.new(params)
    if item_search_params.valid?
      api_results = Amazon::API.search_music_items(item_search_params.query, { :item_page => item_search_params.page })
      render :json => build_json_response(api_results)
    elsif
      flash.now[:error] = item_search_params.errors.messages.values.collect { |e| e[0] }
      logger.debug flash.now[:error]
      render :action => :index
    end
  end

  private
  def build_json_response(api_results)
    return {
      :models => api_results.products,
      :current_page => api_results.current_page,
      :total_page => api_results.total_pages
    }
  end
end


# 検索画面フォーム
class ItemSearchParams
  include ActiveModel::Validations

  attr_accessor :query, :page

  validates :query, :presence => { :message => "検索キーワードを入力してください。" }

  def initialize(params = {})
    @query = params[:query]
    @page = params.fetch(:page, 1)
  end
end
