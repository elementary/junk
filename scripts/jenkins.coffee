module.exports = (robot) ->
  
  robot.router.post "/jenkins-in", (req, res) ->
    switch req.body.name
      when "freya-stable-amd64-iso" then robot.messageRoom "general", "New stable iso is out: http://elementary:vegeta@builds.elementaryos.org/"
      else 
        if req.body.build.status == "FAILURE" && req.body.build.phase == "COMPLETED"
          robot.messageRoom "jenkins", "Build of #{req.body.name} failed: #{req.body.build.full_url}"
          robot.messageRoom "jenkins", '```' + req.body.build.log + '```'
    res.end "ok"
