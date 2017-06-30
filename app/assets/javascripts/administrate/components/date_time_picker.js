$(function () {
  $(".datetimepicker").datetimepicker({
    debug: false,
    format: 'YYYY-MM-DD',
  });


  $(document).on('focus', '.datetimepicker', function(){
    $(this).datetimepicker({
      debug: false,
      format: 'YYYY-MM-DD',
    });
  });
});
