$(function() {
  // Open external links in a new tab/window
  $('a').each(function() {
     var a = new RegExp(window.location.host + '|mailto:|tel:');
     if(!a.test(this.href)) {
         $(this).attr('rel', $.trim([$(this).attr('rel'), 'external'].join(' ')))

         $(this).click(function(event) {
             event.preventDefault(); event.stopPropagation();
             window.open(this.href, '_blank');
         });
     }
  });

  // Landing page client list hover effect
  $('#small-client-list ul li > a:not(.more), #endorsements ul li blockquote').hover(
    function() {
      $(this).animate({ opacity: 1 }, 400, 'swing');
    },
    function() {
      $(this).animate({ opacity: 0.5 }, 400, 'swing');
    }
  );

  // Image attribution
  $('img[data-attribution]').each(function() {
    var attribution = $('<div class="attribution">').append($(this).attr('data-attribution'))

    if($(this).attr('data-attribution-url')) {
      attribution = $('<a rel="nofollow" href="' + $(this).attr('data-attribution-url') + '">').append(attribution);
    }

    $(this).after(attribution);
  });
});
