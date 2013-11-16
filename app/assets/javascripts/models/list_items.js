define(['models/list_item', 'backbone'], function(ListItem, Backbone) {
  var ListItems = Backbone.Collection.extend({
    model: ListItem,
    url: '/list/search',

    initialize: function(check_list_id) {
      this.current_offset = 0;
      this.has_more_item = true;
      this.limit = 20;
      this.check_list_id = check_list_id;
    },

    parse: function(resp) {
      this.current_offset = resp.current_offset;
      this.has_more_item = resp.has_more_item;
      return resp.models;
    },

    is_last_page: function() {
      return !this.has_more_item;
    },

    fetch: function(options) {
      options = options !== undefined ? options : {};
      options = _.extend(options, {
        data: { check_list_id: this.check_list_id, offset: this.current_offset + 1, limit: this.limit },
      });
      return Backbone.Collection.prototype.fetch.call(this, options);
    },

    next: function(options) {
      options = options !== undefined ? options : {};
      options = _.extend(options, {
        reset: false,
        remove: false
      });
      this.fetch(options);
    }
  });

  return ListItems;
});
