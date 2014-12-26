import os
import time
import praw

r = praw.Reddit('elementaryBot v1.0')
r.login(os.environ['BOT_NAME'], os.environ['BOT_PASS'])

sr = r.get_subreddit(os.environ['SUBREDDIT'])
bot = r.get_redditor(os.environ['BOT_NAME'])

while True:
    for submission in sr.get_new(limit=10):
        if submission.link_flair_text == None:
            comment_posted = False
            for comment in submission.comments:
                if comment.author == bot:
                    comment_posted = True

            if not comment_posted:
                submission.add_comment("It appears that you havn't flaired your post. Please click the 'flair' button bellow your post and select the most appropriate label. This helps us keep the subreddit tidy! \n\n **This comment will be deleted when your post is flaired.** \n\n ^Question/Problem? ^Message the moderators!")

    for comment in bot.get_comments(limit=10):
        if comment.submission.link_flair_text != None:
            comment.delete()

    time.sleep(180)
