define(['models/products', 'backbone'], function(Products) {
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

    render: function() {
      this.$el.html(this.product_template(this.model.toJSON()));
      return this;
    }
  });


  var ProductListView = Backbone.View.extend({
    el: "#products_area",

    initialize: function(options) {
      this.listenTo(this.collection, 'reset', this.render);
      this.listenTo(this.collection, 'add', this.onAdd);
    },

    onAdd: function(product) {
      var product_view = new ProductView({ model: product });
      this.$el.append(product_view.render().el);
    },

    render: function(products) {
      // TODO: response の妥当性をチェックする
      // TODO: ページネーションをなんとかする
      var self = this;
      this.$el.empty();
      products.each(function(product) {
        var product_view = new ProductView({ model: product });
        self.$el.append(product_view.render().el);
      });
    }
  });


  var ItemSearchView = Backbone.View.extend({
    el: "#item_search",

    touchThreshold: 35,

    initialize: function(options) {
      this.form = new SearchFormView();
      this.listenTo(this.form, "submit_search_form", this.search);
      this.products = [];
      this.list_view = undefined;
      this.in_loading = false;

      var thisTop = this.$el.offset().top,
      self = this;
      $(window).scroll(function() {
        if (self.in_loading) {
          return;
        }
        var thisHeight = self.$el.height(),
        thisBottom = thisTop + thisHeight,
        nowBottom = $(window).scrollTop() + $(window).height();
        if (nowBottom >= (thisBottom + self.touchThreshold)) {
          self.in_loading = true;
          self.next();
        }
      });
    },

    search: function(query) {
      this.resetCollections();
      this.products.fetch({ data: { query: query }, reset: true });
    },

    resetCollections: function() {
      this.in_loading = false;
      this.products = new Products();
      this.list_view = new ProductListView({ collection: this.products });
      this.listenTo(this.products, 'add', this.afterLoading);
    },

    afterLoading: function() {
      this.in_loading = false;
    },

    next: function() {
      this.products.next();
    }
  });

  return ItemSearchView;
});
