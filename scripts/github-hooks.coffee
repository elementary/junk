# Description:
#   Github Webhooks
#
# Notes:
#   This package is only meant to be used by #TeamPayload
#
#
# Configuration:
#   process.env.WEBHOOK_SECRET_JWT
#   process.env.WEBHOOK_SECRET_STATIC
#   process.env.GITHUB_WEBHOOK_SECRET

secret = process.env.GITHUB_WEBHOOK_SECRET
crypto = require 'crypto'
bufferEq = require 'buffer-equal-constant-time'

room = "rabbit-testing"

module.exports = (robot) ->
  robot.router.post "/github-in", (req, res) ->
    robot.logger.debug req
    ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress

    # end if secret is not set
    if !process.env.GITHUB_WEBHOOK_SECRET
      robot.messageRoom room, "Please set GITHUB_WEBHOOK_SECRET for me" +
      "to secure webhooks"
      return res.end "ok"

    event = req.get('X-Github-Event')
    signature = req.get('X-Hub-Signature')
    payload = req.body
    hash = "sha1=" + crypto.createHmac('sha1', secret)
    .update(JSON.stringify(payload))
    .digest('hex')

    # securely compare the signature with the calculated hmac
    if bufferEq (new Buffer hash), (new Buffer signature)
      robot.emit "gh_#{event}", req.body
      res.end "ok"
    else
      robot.messageRoom room, "LOL: Some idiot tried forging a *Github*" +
      " webhook. The request IP was #{ip}"
      res.end 'LOL! Idiot. These webhooks are secure.'


# This is just for debug purposes
  robot.on "gh_pull_request", (data) ->
    robot.messageRoom room, "#{data.action}: " +
    "#{data.pull_request.title}"

  robot.on "gh_push", (data) ->
    robot.messageRoom room, "New commits in " +
    "#{data.repository.full_name} #{data.ref}\n" +
    "HEAD is now at #{data.head_commit.id.substring(0,8)} " +
    "by #{data.head_commit.author.name} <#{data.head_commit.author.email}>\n" +
    "_#{data.head_commit.message}_"
