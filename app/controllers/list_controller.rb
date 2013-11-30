# coding: utf-8

# リスト画面コントローラー
class ListController < ApplicationController
  def index
    @check_lists = CheckList.where(:user_id => session[:login_user_id]).order("id asc")
  end

  # アイテムをリストへ追加
  def create
    item_add_params = ItemAddParams.new(params)
    if item_add_params.valid?
      res = ListItem.register(
        item_add_params.check_list_id,
        item_add_params.product,
        item_add_params.comment
      )
      render :json => { :list_item_id => res.id }
    elsif
      error_msgs = item_add_params.errors.messages.values.collect { |e| e[0] }
      render :json => { :error => error_msgs }
    end
  end

  def update
    list_item = ListItem.find(params[:id], :lock => true)
    list_item.update_attributes(params[:list])
    render :json => { :updated_item_id => params[:id] }
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


# アイテム追加フォーム
class ItemAddParams
  include ActiveModel::Validations

  attr_accessor :product, :comment, :check_list_id

  def initialize(params = {})
    @comment = params[:comment]
    @product = params[:product]
    @check_list_id = params[:check_list_id]
  end
end
