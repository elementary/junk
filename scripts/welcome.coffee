module.exports = (robot) ->
  robot.enter (msg) ->
    @robot.logger.debug "#{msg.room} was joined by #{msg.user}"
    if msg.room == "general" || msg.room == "rabbit-testing"
      msg.reply "Hey there! Welcome to our elementary Slack, it's like our virtual corporate office. If you require any assistance, please feel free to ask for help. Please remember to stay on-topic and use the appropriate channels for discussion. Have an awesome day!"
