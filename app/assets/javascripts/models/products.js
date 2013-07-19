define(['models/product', 'backbone'], function(Product) {
  var Products = Backbone.Collection.extend({
    model: Product,
    url: 'item_search/search'
  });

  return Products;
});
