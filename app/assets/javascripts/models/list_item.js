define(['backbone'], function() {
  var ListItem = Backbone.Model.extend({
    urlRoot: '/list',

    default: function() {
      return {
        'check_list_id': '',
        'product': undefined,
        'comment': ''
      };
    },

    check: function(item, attrs) {
      attrs.checked = true;
      item.save(attrs, { patch: true });
    }
  });
  return ListItem;
});
