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
        location.reload();
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
  $(modalName).on("show", function() { 
     setPrimaryKeyValueAndDisable();
  });
  $(modalName).on("shown", function(evt) { 
  });
  $(modalName + ' form').validate({
   rules: validationRules,
   submitHandler: function(form){
      ajaxPost(form, modalName);
   }
  });
}

var setPrimaryKeyValueAndDisable = function(){
  var pkey = $('#update-modal .pkey').text();
  $('.pk').val(pkey);
  $('input:text.pk').attr('readonly', 'true');
}

$(function(){
  $('a.btn-mini').on('click', function (event) {
    var pkVal = $(this).data('pkey');
    console.log(pkVal);
    $('.pkey').text(pkVal);
  });
  initForm('#update-modal', {age: "required"});
  initForm('#delete-modal');
});

