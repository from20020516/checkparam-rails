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

// escape ':' because selector reserved.
// TODO: replace colon. that's reserved by SQL too.
function escStr(val) {
  return val.replace(/[ !"#$%&'()*+,.\/:;<=>?@\[\\\]^`{|}~]/g, "\\$&");
}

// Fire when after rendering or Job/Set changed.
function setIcon() {
  // console.log('setIcon', new Date());
  // define tooltip for descriptions. require jQuery and popper.js
  $("[data-toggle='tooltip']").tooltip({ html: true });

  const elInputList = document.querySelectorAll('#gearset .form-control');
  const values = [...elInputList].map((el) => el.value);
  const locale = (document.querySelector("#language .active") || false).id; // js.undefined != ruby.false

  // get JSON of descriptions.
  $.getJSON('/descriptions/', `id=${JSON.stringify(values)}&lang=${JSON.stringify(locale || false)}`)
  .done(function (json) {
    elInputList.forEach(function (formEl) {
      $(`.${formEl.id}`).attr({
        'src': `/icons/${formEl.value || init_icon[formEl.id]}.png`,
        'data-original-title': `${json['descriptions'][formEl.value] ? json['descriptions'][formEl.value] : ''}`,
      })
    })
    document.querySelectorAll('.param').forEach(function (param) {
      let stat = json['checkparam'][param.id] // integer || undefined
      $(`#${escStr(param.id)}`).text(stat || '')
      $(`#${escStr(param.id)}_title`).attr('data-present', Boolean(stat));
    })
  })
}

document.addEventListener('DOMContentLoaded', function () {
  if ($('#gearset')[0]) {
    // fire when .watch(job/set/lang) changed.
    $('.watch').on('ajax:complete', function (event) {
      if ($("body[data-action='show']")[0]) {
        location.reload();
      } else {
        $('#gearset').html(event.detail[0].response);
        setIcon();
      }
    })
    // fire when a equipment changed.
    document.querySelector('#gearset').addEventListener('change', setIcon, { passive: true });
    // fire when page loaded.
    setIcon();
  }
})