define(['jquery'], function() {
  var MugenLoader = function(options) {
    /*
     * 無限ロードを補助するオブジェクト生成関数。
     */
    options = _.defaults(options, {
      touch_threshold : 35,
      _window : window
    });

    this.touch_threshold = options.touch_threshold;
    this.on_next         = options.on_next;
    this.$view           = options.$view;
    this.viewTop         = this.$view.offset().top;
    this._window          = options._window;
    this.stop_loading    = false;
  };

  MugenLoader.prototype.start = function() {
    /*
     * 無限ロードを開始する。
     */
    $(this._window).scroll(_.bind(this.next, this));
  };

  MugenLoader.prototype.stop = function() {
    /*
     * 無限ロードを停止する。
     */
    this.stop_loading = true;
  };

  MugenLoader.prototype.resume = function() {
    /*
     * 無限ロードを再開する。
     */
    this.stop_loading = false;
  };

  MugenLoader.prototype.next = function() {
    /*
     * 次のロードを行う。
     */
    if (!this.stop_loading && this._is_touching_bottom()) {
      this.stop();
      this.on_next();
    }
  };

  MugenLoader.prototype._is_touching_bottom = function() {
    /*
     * スクロール位置が底を突いたか検証する。
     */
    var thisHeight = this.$view.height(),
        $_window = $(this._window),
        thisBottom = this.viewTop + thisHeight,
        nowBottom = $_window.scrollTop() + $_window.height();

    if (nowBottom >= (thisBottom + this.touch_threshold)) {
      return true;
    }
    return false;
  };

  return MugenLoader;
});
