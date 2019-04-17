// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
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

function escStr(val) {
  return val.replace(/[ !"#$%&'()*+,.\/:;<=>?@\[\\\]^`{|}~]/g, "\\$&");
}
// Fire when after rendering or Job/Set changed.
function setIcon() {
  // define tooltip for descriptions. require jQuery and popper.js
  $(function() {
    $('[data-toggle="tooltip"]').tooltip({ html: true });
  })
  const elInputList = document.querySelectorAll('#gearset .form-control');
  const values = [...elInputList].map((el) => el.value);
  $.getJSON("/descriptions/", `id=${JSON.stringify(values)}`) // get JSON of item descriptions.
    .done(function(json) {
      elInputList.forEach(function(formEl) {
        $(`.${formEl.id}`).attr({
          "src": `/icons/64/${formEl.value || init_icon[formEl.id]}.png`,
          "data-original-title": `${json["descriptions"][formEl.value] ? json["descriptions"][formEl.value] : ""}`,
        })
      })
      // console.log(json["checkparam"]);
      document.querySelectorAll('.param').forEach(function(param) {
        let stat = json["checkparam"][param.id] // integer or undefined
        $(`#${escStr(param.id)}`).text(stat || "")
        $(`#${escStr(param.id)}_title`).attr('data-present', Boolean(stat));
      })
    })
}
// Ajax callback for refresh #gearset when user change Job/Set.
(function() {
  $(function() {
    return $('.watch').on('ajax:complete', function(event) { // when .watch changed,
      return $('#gearset').html(event.detail[0].response);
    })
  })
}).call(this)
