define(['models/list_items', 'models/list_item', 'views/helpers/mugen_loader', 'backbone'], function(ListItems, ListItem, MugenLoader) {
  // TODO: この宣言はまとめたい。
  _.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
  };

  var SearchFormView = Backbone.View.extend({
    el: "#list div.check_list_form_area",

    events: {
      "change #check_lists": "handle_select"
    },

    initialize: function(options) {
      this.$check_lists = $("#check_lists");
    },

    handle_select: function() {
      var check_list_id = this.$check_lists.val();
      if (!_.isEmpty(check_list_id)) {
        this.trigger('select_check_list', check_list_id);
      }
    }
  });


  var ListItemView = Backbone.View.extend({
    list_item_template: _.template($("#list_item_template").html()),

    events: { "click .icons .check-item": "handle_check_item" },

    handle_check_item: function(e) {
      e.preventDefault();
      $(".check-item", this.$el).prop('disabled', true);
      this.$el.trigger('check-item', this.model);
      this.$el.fadeOut();
    },

    render: function() {
      this.$el.html(this.list_item_template(this.model.toJSON()));
      return this;
    }
  });


  var ListItemsView = Backbone.View.extend({
    el: "#list_item_area",

    initialize: function(options) {
      this.listenTo(this.collection, 'add', this.render_each_model);
      this.listenTo(this.collection, 'reset', this.render);
    },

    render_each_model: function(list_item) {
      // 各アイテムのレンダリング
      var list_item_view = new ListItemView({ model: list_item });
      this.$el.append(list_item_view.render().el);
    },

    render: function(list_items) {
      // アイテムを空にした上でレンダリング
      // TODO: response の妥当性をチェックする
      this.$el.empty();
      list_items.each(_.bind(this.render_each_model, this));
    }
  });


  var ListView = Backbone.View.extend({
    el: "#list",

    events: { "check-item": "check_item" },

    initialize: function(options) {
      this.form = new SearchFormView();
      this.listenTo(this.form, "select_check_list", this.reload);
      this.list_items = [];
      this.list_view = undefined;
      this.mugen_loader = undefined;
      this.form.handle_select();
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
    },

    check_item: function(e, item) {
      var attrs = {};
      attrs[$("meta[name=csrf-param]").attr('content')] = $("meta[name=csrf-token]").attr('content');
      item.check(attrs);
    }
  });

  return ListView;
});
