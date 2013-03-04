function ajaxPost(form, modalName){
  var furl = $(form).attr('action');
  var fdata = $(form).serialize();
  $.ajax({
      type: 'POST',
      url: furl,
      data: fdata,
      async: true,
      success: function(info){
        $(modalName).modal('hide');
      }
  });
}
function initForm(modalName, validationRules){
  $(modalName).on("hidden", function() { 
     $(modalName + ' form')[0].reset();
   });
  $(modalName + ' form').validate({
   rules: validationRules,
   submitHandler: function(form){
      ajaxPost(form, modalName);
   }
  });
}