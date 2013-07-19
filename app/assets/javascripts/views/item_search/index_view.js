define(['models/products', 'backbone'], function(Products) {
  var SearchFormView = Backbone.View.extend({
    events: {
      "submit #search_form": "handle_submit"
    },

    initialize: function(options) {
      this.$form = $("#search_form");
      this.$query_input = $("#query");
    },

    handle_submit: function(e) {
      e.preventDefault();

      var query = this.$query_input.val();
      if (!_.isEmpty(query)) {
        this.trigger('submit_search_form', { query: query });
        this.$query_input.val('');
      }
    }
  });


  var ProductView = Backbone.View.extend({
    product_template: _.template($("product_template")),

    tagName: "li",

    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    }
  });


  var ProductListView = Backbone.View.extend({
    initialize: function(options) {
      this.listenTo(this.collection, 'reset', this.render_product_views);
    },

    render_product_views: function(collection) {
      // Productview を再描画
    }
  });


  return SearchFormView;
});
