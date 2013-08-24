define(['models/product', 'backbone'], function(Product, Backbone) {
  var Products = Backbone.Collection.extend({
    model: Product,
    url: '/item_search/search',

    initialize: function() {
      this.current_page = 0;
      this.total_page = 0;
      this.query = '';
    },

    parse: function(resp) {
      this.current_page = resp.current_page;
      this.total_page = resp.total_page;
      return resp.models;
    },

    fetch: function(options) {
      this.query = options.data.query;
      return Backbone.Collection.prototype.fetch.call(this, options);
    },

    next: function() {
      this.fetch({ data: { query: this.query, page: this.current_page + 1 }, reset: false, remove: false });
    }
  });

  return Products;
});
