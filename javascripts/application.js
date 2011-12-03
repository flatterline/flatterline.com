$(function() {
  $('#small-client-list ul li > a:not(.more)').hover(
    function() {
      $(this).animate({opacity: 1}, 400, 'swing');
    },
    function() {
      $(this).animate({opacity: 0.25}, 400, 'swing');
    }
  );
});
