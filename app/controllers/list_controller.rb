# coding: utf-8

# リスト画面コントローラー
class ListController < ApplicationController
  def index
    @check_lists = CheckList.where(:user_id => session[:login_user_id])
    @list_items = ListItem.find_with_products(@check_lists[0].id)
  end
end
