class AlterListItems < ActiveRecord::Migration
  def change
    execute "alter table list_items add foreign key(check_list_id) references check_lists(id);"
    execute "alter table list_items add foreign key(product_id) references products(id);"
  end
end
