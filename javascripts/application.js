$(function() {
  // Landing page client list hover effect
  $('#small-client-list ul li > a:not(.more), #endorsements ul li blockquote').hover(
    function() {
      $(this).animate({opacity: 1}, 400, 'swing');
    },
    function() {
      $(this).animate({opacity: 0.5}, 400, 'swing');
    }
  );

  $('img[data-attribution]').each(function() {
    var attribution = $('<div class="attribution">').append($(this).attr('data-attribution'))

    if($(this).attr('data-attribution-url')) {
      attribution = $('<a rel="nofollow" href="' + $(this).attr('data-attribution-url') + '">').append(attribution);
    }

    $(this).after(attribution);
  });
});
