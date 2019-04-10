// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Turbolinks: Js NOT RELOAD after "link_to" at default.
// <%= link_to "TEXT", "PATH", data: {turbolinks: false} %>

// Ajax Callback for switch Job/Set
(function() {
  $(function() {
    return $('.watch').on('ajax:complete', function(event) { // .watch -> Ajaxのcallback対象
      return $('#gearset').html(event.detail[0].response);
    })
  })
}).call(this)

const init_icon = {
  gearset_main: 16622,
  gearset_sub: 12332,
  gearset_range: 17174,
  gearset_ammo: 17326,
  gearset_head: 12523,
  gearset_neck: 13074,
  gearset_ear1: 13358,
  gearset_ear2: 13358,
  gearset_body: 12551,
  gearset_hands: 12679,
  gearset_ring1: 13505,
  gearset_ring2: 13505,
  gearset_back: 13606,
  gearset_waist: 13215,
  gearset_legs: 12807,
  gearset_feet: 12935,
}

// Fire when after rendering or Job/Set changed.
function setIcon() {
  const elInputList = document.querySelectorAll('#gearset .form-control');
  const values = [...elInputList].map((el) => el.value);
  // console.log(values)
  $.getJSON("/descriptions/", `id=${JSON.stringify(values)}`) // get JSON of item descriptions.
  .done(function(json) {
    elInputList.forEach(function(formEl) {
      // console.log(formEl.id, formEl.value);
      $(`.${formEl.id}`).attr({
        "src": `/icons/64/${formEl.value || init_icon[formEl.id]}.png`,
        "data-original-title": `${json["descriptions"][formEl.value] ? json["descriptions"][formEl.value] : ""}`,
      })
    })
    document.querySelectorAll('.param').forEach(function(param) {
      // console.log(param.id, json["checkparam"][param.id]);
      $(`#${param.id}`).text(json["checkparam"][param.id]);
    })
  })
}

// define tooltip for descriptions. require jQuery and popper.js
$(function() {
  $('[data-toggle="tooltip"]').tooltip({ html: true, container: 'body', "data-original-title": "" });
})
