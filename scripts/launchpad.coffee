# Description:
#   Look for Launchpad urls and convert them to something usable
#
# Dependencies:
# None
#
# Commands:
# report <project> - Send a Link to Bug reporting for <project>
# lp <project> - Send a Link to the Launchpad <project>
#
# Author:
# fabianthoma <fabian@elementaryos.org>

module.exports = (robot) ->

  robot.hear /(:?bug|\#) *([0-9]+)/i, (msg) ->
    msg.send "https://bugs.launchpad.net/bugs/" + msg.match[2]
  
  robot.hear /lp:([a-zA-Z0-9\/\-\+\.]+)/i, (msg) ->
    msg.send "https://code.launchpad.net/+branch/" + msg.match[1]
  
  robot.hear /lp:~([a-zA-Z0-9\/\-\+\.]+)/i, (msg) ->
    msg.send "https://code.launchpad.net/~" + msg.match[1]
  
  robot.hear /ppa:([a-zA-Z0-9\-]+)\/([a-zA-Z0-9\-]+)/i,  (msg) ->
    msg.send "https://code.launchpad.net/~" + msg.match[1] + '/+archive/' + msg.match[2]

  robot.respond /report (.*)/i, (msg) ->
    msg.send "Read: http://elementaryos.org/docs/code/reporting-bugs and then report it: https://bugs.launchpad.net/" + msg.match[1]

  robot.respond /lp (.*)/i, (msg) ->
    msg.send "https://launchpad.net/" + msg.match[1]

  robot.router.post "/email-in", (req, res) ->
    robot.messageRoom "rabbit-testing", req.body.subject
    res.end "ok"
