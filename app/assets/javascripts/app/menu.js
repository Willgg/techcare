if ( $(window).width() > 1024) {
  var jsEvent = 'mouseenter mouseleave'
}
else {
  var jsEvent = 'click'
}

$( '.chat-card' ).on( jsEvent, '.message', function() {
    $( '.menu', this ).toggle();
});
