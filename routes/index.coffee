exports.index = (req, res) ->
  res.render "index",
    title: "Express"
    
exports.nameage = (req, res) ->
  console.log -111, req.body
  res.send "blah"