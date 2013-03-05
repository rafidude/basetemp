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
      },
      failure: function(err){
        alert(err.error);
      }
  });
}
function initForm(modalName, validationRules){
  $(modalName).on("hidden", function() { 
     $(modalName + ' form')[0].reset();
  });
  $(modalName).on("show", function(evt) { 
     console.log(evt.target);
  });
  $(modalName + ' form').validate({
   rules: validationRules,
   submitHandler: function(form){
      ajaxPost(form, modalName);
   }
  });
}