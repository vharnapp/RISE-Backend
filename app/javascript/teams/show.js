import $ from 'jquery';
import 'jquery-circle-progress';

$(document).on('turbolinks:load', function() {
  $('.circle').circleProgress({
    startAngle: -Math.PI / 2,
    size: '60',
    thickness: '3',
    animationStartValue: '0',
    fill: { color: "#96E17D" },
    emptyFill: '#fff',
  });
});
