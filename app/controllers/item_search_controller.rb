# coding: utf-8

require 'amazon'

# 検索画面コントローラー
class ItemSearchController < ApplicationController
  def search
    # TODO: エラーのときも json で返す
    form = ItemSearchForm.new params
    if form.valid?
      items = Amazon::API.search_music_items form.query
      render :json => items.products
    elsif
      flash.now[:error] = form.errors.messages.values.collect { |e| e[0] }
      render :action => :index
    end
  end
end


# 検索画面フォーム
class ItemSearchForm
  include ActiveModel::Validations

  attr_accessor :query

  validates :query, :presence => { :message => "検索キーワードを入力してください。" }

  def initialize params = {}
    @query = params[:query]
  end
end
