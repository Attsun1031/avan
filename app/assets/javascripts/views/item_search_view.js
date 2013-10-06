define(['models/products', 'backbone', 'jquery.ui.all'], function(Products) {
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
      var item_name = this.$el.find('a').html();
      /*
       * 疑問点：
       * Productlistviewは add_item イベントを listen_to で登録していないので、
       * backbone の trigger を使うとイベントは伝播しない。
       * ProductlistviewがProductViewを生成するたびに listenToしたら効率悪くなりそうだが、
       * addEventListenerが呼ばれるわけではないのでそうでもないのだろうか。
       * まぁでもjsの組み込みのイベントハンドリングの仕組みを使うよりは伝播が遅くなるだろうし、
       * Productviewが増えるたびにコールバック情報を抱え込むのも徐々にメモリを圧迫しそう。
       */
      this.$el.trigger('add_item', item_name);
    },

    render: function() {
      this.$el.html(this.product_template(this.model.toJSON()));
      return this;
    }
  });


  var AddDialogView = Backbone.View.extend({
    el: "#add_dialog"
  });


  var ProductListView = Backbone.View.extend({
    el: "#products_area",

    events: {
      "add_item": "add_item"
    },

    initialize: function(options) {
      this.listenTo(this.collection, 'reset', this.render);
      this.listenTo(this.collection, 'add', this.render_each_model);
    },

    add_item: function(e, item_name) {
      // TODO: チェックリスト選択、コメント追加のモーダルダイアログを表示する。
      console.log(item_name);
    },

    render_each_model: function(product) {
      // 各アイテムのレンダリング
      var product_view = new ProductView({ model: product });
      this.$el.append(product_view.render().el);
    },

    render: function(products) {
      // アイテムを空にした上でレンダリング
      // TODO: response の妥当性をチェックする
      var self = this;
      this.$el.empty();
      products.each(function(product) {
        self.render_each_model(product);
      });
    }
  });


  var ItemSearchView = Backbone.View.extend({
    el: "#item_search",

    touch_threshold: 35,

    initialize: function(options) {
      this.form = new SearchFormView();
      this.listenTo(this.form, "submit_search_form", this.reload);
      this.products = [];
      this.list_view = undefined;
      this.in_loading = false;
      this.viewTop = this.$el.offset().top;

      $(window).scroll(_.bind(this.next, this));
    },

    reload: function(query) {
      // コレクションをリロード
      this.in_loading = true;
      this.products = new Products();
      this.list_view = new ProductListView({ collection: this.products });
      this.products.fetch({ data: { query: query }, reset: true, success: _.bind(this._on_after_loading, this) });
    },

    next: function() {
      // コレクションを追加ロード
      if (!this.in_loading && this._is_touching_bottom()) {
        this.in_loading = true;
        this.products.next({ success: _.bind(this._on_after_loading, this) });
      }
    },

    _is_touching_bottom: function() {
      // スクロール位置が底を突いたか検証する。
      var thisHeight = this.$el.height(),
      $window = $(window),
      thisBottom = this.viewTop + thisHeight,
      nowBottom = $window.scrollTop() + $window.height();
      if (nowBottom >= (thisBottom + this.touch_threshold)) {
        return true;
      }
      return false;
    },

    _on_after_loading: function() {
      // ロード後の処理
      if (!this.products.is_last_page()) {
        this.in_loading = false;
      }
    }
  });

  return ItemSearchView;
});
