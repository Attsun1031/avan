define(['backbone'], function() {
  var Product = Backbone.Model.extend({
    default: function() {
      return {
        'asin': '',
        'title': '',
        'category': '',
        'creater_name': '',
        'image_url': '',
        'item_url': ''
      };
    }
  });
  return Product;
});
