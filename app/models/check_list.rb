# coding: utf-8

# チェックリスト
class CheckList < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name

  def add_item(product, comment = "")
    ListItem.register(self.id, product, comment)
  end

  def self.register(user_id, name, allow_ex = true)
    new_list = self.new
    new_list.name = name
    new_list.user_id = user_id
    if allow_ex
      new_list.save!
    else
      new_list.save
    end
  end
end
