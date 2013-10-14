define(['backbone'], function() {
  var ListItem = Backbone.Model.extend({
    url: '/item_search/add',

    default: function() {
      return {
        'check_list_id': '',
        'product': undefined,
        'comment': ''
      };
    }
  });
  return ListItem;
});
