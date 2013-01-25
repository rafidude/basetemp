function ajaxPost(form, modalName){
  var furl = $(form).attr('action');
  var fdata = $(form).serialize();
  $.ajax({
      type: 'POST',
      url: furl,
      data: fdata,
      async: true,
      success: function(info){
        var bhtml = "<div class='alert alert-info'>" + info + "</div>";
        //$('#alertMessages').html(bhtml);
        alert(info);
        $(modalName).modal('hide');
        $(modalName).remove();
      }
  });
}