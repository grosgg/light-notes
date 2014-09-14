// Put your application scripts here
$( document ).ready(function() {
  $('#btn-evernote-sync').click(function () {
    var btn = $(this);
    btn.button('loading');
    window.location.href = btn.attr('data-url');
  });

  $('.share-link input').click(function () {
    $(this).select();
  });
});