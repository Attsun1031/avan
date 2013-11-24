# coding: utf-8

# リスト画面コントローラー
class ListController < ApplicationController
  def index
    @check_lists = CheckList.where(:user_id => session[:login_user_id])
  end

  def search
    item_search_params = ListItemSearchParams.new(params)
    logger.debug params
    if item_search_params.valid?
      results, has_more_item  = ListItem.find_with_products(
        item_search_params.check_list_id,
        true,
        item_search_params.offset,
        item_search_params.limit
      )
      render :json => build_json_response(results, has_more_item, item_search_params)

    elsif
      flash.now[:error] = item_search_params.errors.messages.values.collect { |e| e[0] }
      render :action => :index
    end
  end

  private
  def build_json_response(results, has_more_item, item_search_params)
    return {
      :models => results,
      :current_offset => item_search_params.offset + results.length,
      :has_more_item => has_more_item
    }
  end
end


# 検索画面フォーム
class ListItemSearchParams
  include ActiveModel::Validations

  attr_accessor :check_list_id, :offset, :limit

  validates :check_list_id, :presence => { :message => "チェックリストを選択してください。" }
  validates :limit, :numericality => { :only_integer => true }
  validates :offset, :numericality => { :only_integer => true }

  def initialize(params = {})
    @check_list_id = params[:check_list_id]
    @offset = params.fetch(:offset, 0).to_i
    @limit = params.fetch(:limit, 1).to_i
  end
end

