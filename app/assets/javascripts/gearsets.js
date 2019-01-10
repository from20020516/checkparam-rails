// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Turbolinks: Js NOT RELOAD after "link_to" at default.
// <%= link_to "TEXT", "PATH", data: {turbolinks: false} %>

// Ajax Callback
(function() {
  $(function() {
    return $('.watch').on('ajax:complete', function(event) { // .watch -> Ajaxのcallback対象
      return $('#gearset').html(event.detail[0].response);
    });
  });
}).call(this);
