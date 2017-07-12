$(document).on('turbolinks:load', function() {
  console.log('(document).turbolinks:load')
  $(document).foundation();

  // Coach dashboard
  $('.unlock-pyramid-module-checkbox').on('change', function(){
    var user_id = $(this).data('user-id');
    var pyramid_module_id = $(this).data('pyramid-module-id');
    var unlocked_pyramid_module_id = $(this).data('unlocked-pyramid-module-id');
    var $that = $(this);

    if (unlocked_pyramid_module_id == undefined){
      var method = 'POST'
      var url = ''
      var locked_unlocked_text = 'Unlocked'
    } else {
      var method = 'DELETE'
      var url = unlocked_pyramid_module_id;
      var locked_unlocked_text = 'Locked'
    }

    $.ajax({
      url: '/unlocked_pyramid_modules/' + url,
      method: method,
      data: {
        user_id: user_id,
        pyramid_module_id: pyramid_module_id,
      },
      success: function(data){
        // console.log('success');
        $that.data('unlocked-pyramid-module-id', data.unlocked_pyramid_module_id);
        flashMini('Pyramid Module ' + locked_unlocked_text, 'body');
      }
    });
  });
});
