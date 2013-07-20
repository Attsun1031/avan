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

    initialize: function(options) {
      this.form = new SearchFormView();
      this.products = new Products();
      this.list_view = new ProductListView({ collection: this.products });
      this.listenTo(this.form, "submit_search_form", this.search);
    },

    search: function(query) {
      this.products.fetch({ data: { query: query }, reset: true });
    }
  });

  return ItemSearchView;
});
