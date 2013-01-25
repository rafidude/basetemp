function ajaxPost(form, modalName){
  var furl = $(form).attr('action');
  var fdata = $(form).serialize();
  $.ajax({
      type: 'POST',
      url: furl,
      data: fdata,
      async: true,
      success: function(info){
        alert(info);
        $(modalName).modal('hide');
        $(modalName).remove();
      }
  });
}