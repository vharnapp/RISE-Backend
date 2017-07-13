(function() {
  this.flashMini = function(text, appendTo){
    if($('.mini-flash').length == 0) {
      $(appendTo).after("<span class='flash-mini flash-notice'>" + text + "</span>");
      fadeFlash('.flash-mini', 1000);
    };
  };
}).call(this);

(function() {
  this.fadeFlash = function(classToRemove, delay){
    setTimeout(function(){
      removeFlash(classToRemove)
    }, delay);
  };
}).call(this);

(function() {
  this.removeFlash = function(classToRemove){
    $(classToRemove).fadeOut('slow', function() {
      $(this).remove();
    });
  };
}).call(this);

fadeFlash('.flashes', 8000);

$(document).on('click', '.remove-flash', function(e){
  e.preventDefault();
  removeFlash('.flashes');
});
