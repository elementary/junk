module.exports = (robot) ->
  
  robot.router.post "/jenkins-in", (req, res) ->
    if req.body.build.phase == "COMPLETED"
      switch req.body.name
        when "freya-stable-amd64-iso"
          if req.body.build.status == "SUCCESS" 
            robot.messageRoom "general", "New stable iso is out: http://elementary:vegeta@builds.elementaryos.org/"
          else
            robot.messageRoom "jenkins", "Build of #{req.body.name} failed: #{req.body.build.full_url}"
            robot.messageRoom "jenkins", '```' + req.body.build.log + '```'
        when "mvp"
          if req.body.build.status == "SUCCESS" 
            robot.messageRoom "web", "Build of MVP successfull: #{req.body.build.full_url}"
          else
            robot.messageRoom "web", "Build of MVP failed: #{req.body.build.full_url}"
            robot.messageRoom "web", '```' + req.body.build.log + '```'
        else
          if req.body.build.status == "FAILURE"
            robot.messageRoom "jenkins", "Build of #{req.body.name} failed: #{req.body.build.full_url}"
            robot.messageRoom "jenkins", '```' + req.body.build.log + '```'
    res.end "ok"
