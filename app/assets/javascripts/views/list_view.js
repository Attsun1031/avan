define(['models/list_items', 'models/list_item', 'views/helpers/mugen_loader', 'backbone'], function(ListItems, ListItem, MugenLoader) {
  // TODO: この宣言はまとめたい。
  _.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
  };

  var SearchFormView = Backbone.View.extend({
    el: "#list div.check_list_form_area",

    events: {
      "submit #search_form": "handle_submit"
    },

    initialize: function(options) {
      this.$check_lists = $("#check_lists");
    },

    handle_submit: function(e) {
      e.preventDefault();

      var check_list_id = this.$check_lists.val();
      if (!_.isEmpty(check_list_id)) {
        this.trigger('submit_search_form', check_list_id);
      }
    }
  });


  var ListItemView = Backbone.View.extend({
    list_item_template: _.template($("#list_item_template").html()),

    events: { "click .icons .add-item": "handle_add_item" },

    handle_add_item: function(e) {
      e.preventDefault();
      this.$el.trigger('add_item', this.model.toJSON());
    },

    render: function() {
      this.$el.html(this.list_item_template(this.model.toJSON()));
      return this;
    }
  });


  var ListItemsView = Backbone.View.extend({
    el: "#list_items_area",

    initialize: function(options) {
      this.listenTo(this.collection, 'add', this.render_each_model);
    },

    render_each_model: function(list_item) {
      // 各アイテムのレンダリング
      var list_item_view = new ListItemView({ model: list_item });
      this.$el.append(list_item_view.render().el);
    }
  });


  var ListView = Backbone.View.extend({
    el: "#list",

    events: { "add_item": "add_item2list" },

    initialize: function(options) {
      this.form = new SearchFormView();
      this.listenTo(this.form, "submit_search_form", this.reload);
      this.list_items = [];
      this.list_view = undefined;
      this.mugen_loader = undefined;
    },

    reload: function(check_list_id) {
      /*
       * アイテムをリロードする。
       * 無限ローダーも初期化される。
       */
      this.mugen_loader = new MugenLoader({
        on_next : _.bind(this.next, this),
        $view   : this.$el
      });
      this.list_items = new ListItems(check_list_id);
      this.list_view = new ListItemsView({ collection: this.list_items });
      this.list_items.fetch({
        reset   : true,
        success : _.bind(this.mugen_loader.start, this.mugen_loader)
      });
    },

    next: function() {
      this.list_items.next({ success: _.bind(this.on_after_loading, this) });
    },

    on_after_loading: function() {
      if (!this.list_items.is_last_page()) {
        // まだアイテムがあればロードを再開する。
        this.mugen_loader.resume();
      }
    }
  });

  return ListView;
});
