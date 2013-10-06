# coding: utf-8

require 'amazon'

# 検索画面コントローラー
class ItemSearchController < ApplicationController
  def search
    # TODO: エラーのときも json で返す
    form = ItemSearchForm.new(params)
    if form.valid?
      api_results = Amazon::API.search_music_items(form.query, { :item_page => form.page })
      render :json => build_json_response(api_results)
    elsif
      flash.now[:error] = form.errors.messages.values.collect { |e| e[0] }
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

class ItemAddController < ApplicationController
  def add
    render :json => {:x => 1}
  end
end


# 検索画面フォーム
class ItemSearchForm
  include ActiveModel::Validations

  attr_accessor :query, :page

  validates :query, :presence => { :message => "検索キーワードを入力してください。" }

  def initialize params = {}
    @query = params[:query]
    @page = params.fetch(:page, 1)
  end
end
