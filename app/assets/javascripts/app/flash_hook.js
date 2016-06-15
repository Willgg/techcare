// FLASH NOTICE ANIMATION
var fade_flash = function() {
    $("#flash_notice").delay(2500).fadeOut("slow");
    $("#flash_alert").delay(2500).fadeOut("slow");
    $("#flash_error").delay(2500).fadeOut("slow");
};

fade_flash();

var show_ajax_message = function(msg, type) {
  if (type != 'alert') {
    var alert_class = 'alert-info';
  }
  else {
    var alert_class = 'alert-warning';
  }
  var flash_html = '<div class="alert ' + alert_class + ' alert-dismissible" id="flash_'+ type +'" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>' + msg + '</div>';
  $("#flash-hook").hide().html(flash_html).fadeIn('slow');
  fade_flash();
};

$(document).ajaxComplete(function(event, request) {
  if (request.getResponseHeader('X-Message-Type').indexOf('empty') != 0) {
    var msg = request.getResponseHeader('X-Message');
    var type = request.getResponseHeader('X-Message-Type');
    show_ajax_message(msg, type);
  }
});
