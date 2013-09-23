# coding: utf-8

# チェックリスト
class CheckList < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name

  def add_item(product, comment = "")
    ListItem.register(self, product, comment)
  end

  def self.register(user, name)
    new_list = self.new
    new_list.name = name
    new_list.user_id = user.id
    new_list.save
  end
end
