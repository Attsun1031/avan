# coding: utf-8

# リスト画面コントローラー
class ListController < ApplicationController
  def index
    @check_lists = CheckList.where(:user_id => session[:login_user_id])
  end

  def search
    item_search_params = ItemSearchParams.new(params)
    if item_search_params.valid?
      results = ListItem.find_with_products(
        item_search_params.check_list_id,
        true,
        item_search_params.offset,
        item_add_params.limit
      )
      render :json => build_json_response(results, item_search_params)

    elsif
      flash.now[:error] = item_search_params.errors.messages.values.collect { |e| e[0] }
      render :action => :index
    end
  end

  private
  def build_json_response resutls, item_search_params
    # TODO: 実装
  end
end


# 検索画面フォーム
class ItemSearchParams
  include ActiveModel::Validations

  attr_accessor :check_list_id, :page

  validates :check_list_id, :presence => { :message => "チェックリストを選択してください。" }

  def initialize(params = {})
    @query = params[:check_list_id]
    @offset = params.fetch(:offset, 1)
    @limit = params.fetch(:limit, 1)
  end
end

