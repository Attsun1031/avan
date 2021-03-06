define(['models/products', 'models/list_item', 'views/helpers/mugen_loader', 'backbone', 'jquery.ui.all'], function(Products, ListItem, MugenLoader) {
  // TODO: この宣言はまとめたい。
  _.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
  };

  var SearchFormView = Backbone.View.extend({
    el: "#item_search div.item_search_form_area",

    events: {
      "submit #search_form": "handle_submit"
    },

    initialize: function(options) {
      this.$query_input = $("#query");
    },

    handle_submit: function(e) {
      e.preventDefault();

      var query = this.$query_input.val();
      if (!_.isEmpty(query)) {
        this.trigger('submit_search_form', query);
      }
    }
  });


  var ProductView = Backbone.View.extend({
    product_template: _.template($("#product_template").html()),

    events: {
      "click .icons .add-item": "handle_add_item"
    },

    handle_add_item: function(e) {
      e.preventDefault();
      /*
       * 疑問点：
       * Productlistviewは add_item イベントを listen_to で登録していないので、
       * backbone の trigger を使うとイベントは伝播しない。
       * ProductlistviewがProductViewを生成するたびに listenToしたら効率悪くなりそうだが、
       * addEventListenerが呼ばれるわけではないのでそうでもないのだろうか。
       * まぁでもjsの組み込みのイベントハンドリングの仕組みを使うよりは伝播が遅くなるだろうし、
       * Productviewが増えるたびにコールバック情報を抱え込むのも徐々にメモリを圧迫しそう。
       */
      this.$el.trigger('add_item', this.model.toJSON());
    },

    render: function() {
      this.$el.html(this.product_template(this.model.toJSON()));
      return this;
    }
  });


  var AddItemDialog = Backbone.View.extend({
    el: "#add-item-dialog",

    initialize: function(options) {
      this.$target_item = $("#target-item");
      this.current_item = undefined;

      // ダイアログの初期化
      this.$el.dialog({
        autoOpen : false,
        height   : 330,
        width    : 400,
        modal    : true,
        buttons  : {
          "追加する"   : _.bind(this._submit, this),
          "キャンセル" : _.bind(this._cancel, this)
        }
      });
    },

    _submit: function() {
      var list = this._build_list_obj();
      list.save(null, {
        "success": _.bind(function(model, response) {
          this.$el.dialog("close");
          this._clear();
        }, this),
        "error": _.bind(function(model, response) {
          this.$el.dialog("close");
          this._clear();
        }, this)
      });
    },

    _build_list_obj: function() {
      /*
       * 更新用のリストアイテムオブジェクトを生成する。
       */
      var list = new ListItem(), list_product = {};

      // 更新用 product 情報から null 項目は除く。
      // 通信量削減 && rails で モデルの id に nil をセットすることによる例外の回避用。
      _.each(_.keys(this.current_item), _.bind(function(k) {
        if (this.current_item[k] !== null) {
          list_product[k] = this.current_item[k];
        }
      }, this));

      list.set({
        "comment": $("#comment").val(),
        "product": list_product,
        "check_list_id": $("#checklists").val(),
        "authenticity_token": $("#authenticity_token", this.$el).val()
      });

      return list;
    },

    _cancel: function() {
      this.$el.dialog("close");
      this.current_item = undefined;
      this._clear();
    },

    _setup_dialog: function() {
      this.$target_item.text(this.current_item.title);
    },

    _clear: function() {
      this.current_item = undefined;
      this.$target_item.text("");
      $("#comment", this.$el).val("");
    },

    handle_add_item: function(item) {
      this.current_item = item;
      this._setup_dialog();
      this.$el.dialog("open");
    }
  });


  var ProductListView = Backbone.View.extend({
    el: "#products_area",

    initialize: function(options) {
      this.listenTo(this.collection, 'reset', this.render);
      this.listenTo(this.collection, 'add', this.render_each_model);
    },

    render_each_model: function(product) {
      // 各アイテムのレンダリング
      var product_view = new ProductView({ model: product });
      this.$el.append(product_view.render().el);
    },

    render: function(products) {
      // アイテムを空にした上でレンダリング
      // TODO: response の妥当性をチェックする
      this.$el.empty();
      products.each(_.bind(this.render_each_model, this));
    }
  });

  var ItemSearchView = Backbone.View.extend({
    el: "#item_search",

    events: { "add_item": "add_item2list" },

    initialize: function(options) {
      this.form = new SearchFormView();
      this.add_item_dialog = new AddItemDialog();
      this.listenTo(this.form, "submit_search_form", this.reload);
      this.products = [];
      this.list_view = undefined;
      this.mugen_loader = undefined;
    },

    reload: function(query) {
      /*
       * アイテムをリロードする。
       * 無限ローダーも初期化される。
       */
      this.mugen_loader = new MugenLoader({
        on_next : _.bind(this.next, this),
        $view   : this.$el
      });
      this.products = new Products();
      this.list_view = new ProductListView({ collection: this.products });
      this.products.fetch({
        data    : { query : query },
        reset   : true,
        success : _.bind(this.mugen_loader.start, this.mugen_loader)
      });
    },

    next: function() {
      this.products.next({ success: _.bind(this.on_after_loading, this) });
    },

    add_item2list: function(e, item) {
      this.add_item_dialog.handle_add_item(item);
    },

    on_after_loading: function() {
      if (!this.products.is_last_page()) {
        // まだアイテムがあればロードを再会する。
        this.mugen_loader.resume();
      }
    }
  });

  return ItemSearchView;
});
