$(document).ready(function() {
  $('.action-links a:last-of-type').on('click', function(event) {
    event.preventDefault();
    $('#add-data-card').hide();
    createCookie("data_card_read", "true", 2);
  });

  $('body').on('change', 'input:file',function (){
    var fileName = $(this).val();
    $('label').html(fileName);
  });
});


function createCookie(name,value,days) {
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
  }
  else var expires = "";
  document.cookie = name+"="+value+expires+";";
}




