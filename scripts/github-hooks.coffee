module.exports = (robot) ->
  robot.router.post "/github-in", (req, res) ->
    @robot.logger.debug req
    event = req.get 'X-Github-Event'
    signature = req.get 'X-Hub-Signature'
    //TODO: Add validation of signature
    @robot.emit 'gh_' + event, req.body
    res.end "ok"