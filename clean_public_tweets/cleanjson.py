#!/usr/bin/env python2

"""Clean and Simplify Twitter JSON

Run with:
python cleanjson.py /path/in /path/out/foo_


-- could output tweets that failed parsing, but basic inspection suggests they are simple delete commands.
"""

import ujson
import os
import fnmatch
import string
import pandas as pd
import sys
import codecs

path = sys.argv[1]
pathout = sys.argv[2]

#---------------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------------
print("finding files...")

data = [os.path.join(dirpath, f)
        for dirpath, dirnames, files in os.walk(path)
        for f in fnmatch.filter(files, '*.json')]


print("num files in: ", len(data))
#-----------------------------------------------------------

#-----------------------------------------------------------
def consolidate_multiline_tweets(f1):
        tweets = []
        with codecs.open(f1, encoding='utf8') as f:
                try:
                        for line in f.readlines():
                                try:
                                        tweets.append(ujson.loads(line))
                                except:
                                        print("failed tweet")
                except:
                        print("failed file")
        return(tweets)
#-----------------------------------------------------------

#-----------------------------------------------------------
def parse_tweet(t):
        row = {}
        try:
                lang = t['lang']
        except:
                lang = t['user']['lang']
        text = t['text'].replace('\n', ' ').replace(",", ' ').encode('utf-8')
        try:
                hasht = t['entities']['hashtags'][0]['text']
        except:
                hasht = ''
        try:
                followers = t['user']['followers_count']
                utc = t['user']['utc_offset']
        except:
                followers = None
                utc = ''
        try:
                retw = t['retweeted']
        except:
                retw = False
        row = {'id_str': t['id_str'], 'created_at': t['created_at'], 'utc_offset': utc,
                'favorited': t['favorited'], 'retweeted': retw,
                'hashtags': hasht, 'lang': lang, 'followers_count': followers,  'text': text}
        return(row)
#-----------------------------------------------------------

#-----------------------------------------------------------
def generate_rows(tweets):
        rows = []
#       errors = []
        for t in tweets:
                try:
                        row = parse_tweet(t)
                        rows.append(row)
                except:
                        #errors.append(t)
                        continue
        return(rows) #return(rows, errors)
#-----------------------------------------------------------

#-----------------------------------------------------------
def write_json_rows(rows, docfilepath, encode_html=True):
        """ Note that we are appending"""
        with open(docfilepath, 'a') as fp:
                for row in rows:
                        ujson.dump(row, fp, encode_html_chars=encode_html)
                        fp.write('\n')
#-----------------------------------------------------------

#-----------------------------------------------------------
def clean_json(filelist, docfilepath):
        for f1 in filelist:
                tweets = consolidate_multiline_tweets(f1)
                rows = generate_rows(tweets)
                print(len(rows))
                write_json_rows(rows, docfilepath) # NB this appends to the file.
#-----------------------------------------------------------

#-----------------------------------------------------------
numfiles = 100
dt = len(data)
nfilesin = dt/numfiles
for i in range(numfiles)[:]:
        start = nfilesin*i
        end = nfilesin*(i+1)
        print("start: ", str(start), "end: ", str(end))
        outfilename = pathout  + str(i)+ ".json"
        clean_json(data[start:end], outfilename)

print("Done.")

