# RabbitBot

    (\_/) 
    (o.o) ---- Let's get some work done
    (")(")
    
RabbitBot is a chat bot built on the [Hubot](https://hubot.github.com/) framework. It's deployed on our own Servers and provides information and support in our chatrooms on slack.

To get RabbitBot into your Slack channel, just invite him there, he'll happily join you.

### Running RabbitBot Locally

You can test your hubot by running the following.

You can start RabbitBot locally by running:

    % bin/hubot

You'll see some start up output about where your scripts come from and a
prompt:

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/src/scripts
    Hubot>

Then you can interact with RabbitBot by typing `RabbitBot help`.

    RabbitBot> RabbitBot help

    RabbitBot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...


### Scripting

An example script is included at `scripts/example.coffee`, so check it out to
get started, along with the [Scripting Guide](https://github.com/github/hubot/blob/master/docs/scripting.md).

For many common tasks, there's a good chance someone has already one to do just
the thing.


# Deployment

Jenkins will always deploy the latest master branch for RabbitBot. So any accepted merges should be available in chat right away!
