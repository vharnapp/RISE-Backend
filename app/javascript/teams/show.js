import $ from 'jquery';
import 'jquery-circle-progress';

$(document).on('turbolinks:load', function() {
  $('#circle').circleProgress({
    value: 0.75,
    size: 80,
    fill: {
      gradient: ["red", "orange"]
    }
  });
});
