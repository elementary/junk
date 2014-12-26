import os
import time
import praw

r = praw.Reddit('elementaryBot v1.0')
r.login(os.environ['REDDIT_USER'], os.environ['REDDIT_PASS'])

sr = r.get_subreddit('roryj')
bot = r.get_redditor('elementaryBot')

while True:
    for submission in sr.get_new(limit=10):
        if submission.link_flair_text == None:
            comment_posted = False
            for comment in submission.comments:
                if comment.author == bot:
                    comment_posted = True

            if not comment_posted:
                submission.add_comment('Please flair yo post!')

    for comment in bot.get_comments(limit=10):
        if comment.submission.link_flair_text != None:
            comment.delete()

    time.sleep(180)
