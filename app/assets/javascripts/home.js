// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function() {
  $(function() {
    return $('#main_job').on('ajax:complete', function(event) {
      return $('#equipset').html(event.detail[0].response);
    });
  });
}).call(this);
