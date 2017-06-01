jQuery(function($) {
  // Keeps TDs the correct width when draging around.
  if ($('#table_body_id').length > 0) {
    table_width = $('#table_body_id').width();
    cells = $('.table').find('tr')[0].cells.length;
    desired_width = table_width / cells + 'px';
    $('.table td').css('width', desired_width);
  }

  // Actually handles sorting
  $('#table_body_id').sortable({
    axis: 'y',
    cursor: 'move',
    containment: '.table-responsive',
    sort: function(e, ui) {
      ui.item.addClass('active-item-shadow');
    },
    stop: function(e, ui) {
      ui.item.removeClass('active-item-shadow');
      ui.item.children('td').effect('highlight', {}, 1000);
    },
    update: function(event, ui) {
      const all_row_ids = $(this).sortable('toArray', { attribute: 'data-table-row-id' });
      const parent_model = $(this).closest('.main-content__body').attr('data-parent-model-name');
      const parent_model_id = $(this).closest('table').attr('data-sortable-parent-model-id');
      const sortable_model =  $(this).closest('table').attr('data-sortable-model');
      const resource_model =  $(this).closest('table').attr('data-resource-model');
      const url =             $(this).closest('table').attr('data-sortable-update-endpoint');
      $.ajax({
        url: url,
        method: 'PUT',
        data: {
          ids: all_row_ids,
          parent_model: parent_model,
          parent_model_id: parent_model_id,
          sortable_model: sortable_model,
          resource_model: resource_model
        },
        success: function(){
          $('#table_body_id > tr').each(function(i, tr) {
            $('.index:first', this).html(i + 1);
          });

          // console.log("success");
        }
      });
    }
  });
});
