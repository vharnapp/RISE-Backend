import $ from 'jquery';
import 'jquery-circle-progress';

$(document).on('turbolinks:load', function() {
  $('.circle').circleProgress({
    startAngle: -Math.PI / 2,
    size: '50',
    thickness: '3',
    animationStartValue: '0',
  });
});
