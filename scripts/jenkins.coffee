module.exports = (robot) ->
  
  robot.router.post "/jenkins-in", (req, res) ->
    if req.body.build.phase == "COMPLETED"
      if req.body.build.status == "FAILURE"
        robot.messageRoom "jenkins", "Build of #{req.body.name} failed: #{req.body.build.full_url}"
        robot.messageRoom "jenkins", '```' + req.body.build.log + '```'
      switch req.body.name
        when "freya-stable-amd64-iso"
          if req.body.build.status == "SUCCESS" 
            robot.messageRoom "general", "New stable iso is out: http://elementary:vegeta@builds.elementaryos.org/"
    res.end "ok"
