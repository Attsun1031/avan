# coding: utf-8

# リスト画面コントローラー
class ListController < ApplicationController

  # 一回でロードするリストアイテム数
  BULK_LOAD_COUNT = 10

  def index
    @check_lists = CheckList.where(:user_id => session[:login_user_id])
    @list_items = ListItems.find_with_products(0)
  end
end
