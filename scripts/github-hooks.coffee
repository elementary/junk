module.exports = (robot) ->
  robot.router.post "/github-in", (req, res) ->
    robot.logger.debug req
    event = req.get('X-Github-Event')
    signature = req.get('X-Hub-Signature')
    #TODO: Add validation of signature
    robot.emit "gh_#{event}", req.body
    res.end "ok"

  robot.on "gh_pull_request", (data) ->
    robot.messageRoom "rabbit-testing", "#{data.action}: #{data.pull_request.title}"

  robot.on "gh_push", (data) ->
    robot.messageRoom "rabbit-testing", "#{data.size} new commits in #{data.repository.full_name} #{data.ref}"
