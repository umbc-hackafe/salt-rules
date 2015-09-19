#!/usr/bin/python
import os
import sys
from apiclient.discovery import build
from apiclient.errors import HttpError
from oauth2client.tools import argparser


# Set DEVELOPER_KEY to the API key value from the APIs & auth > Registered apps
# tab of
#   https://cloud.google.com/console
# Please ensure that you have enabled the YouTube Data API for your project.
DEVELOPER_KEY = "AIzaSyCg9pQ4p-wMVVDvcVhYK21oerAPqtPZk3E"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

def youtube_search(options):
  youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION,
    developerKey=DEVELOPER_KEY)

  # Call the search.list method to retrieve results matching the specified
  # query term.
  search_response = youtube.search().list(
    q=options,
    part="id,snippet",
    maxResults=1
  ).execute()

  videos = []

  # Add each result to the appropriate list, and then display the lists of
  # matching videos, channels, and playlists.
  for search_result in search_response.get("items", []):
    if search_result["id"]["kind"] == "youtube#video":
      print(search_result["snippet"]["title"])
      play(search_result["id"]["videoId"])
      return


def play(video):
  os.system("/usr/bin/castnow --device \"Living Room\" https://www.youtube.com/watch?v=%s &" % video)

if __name__ == "__main__":
  try:
    youtube_search(" ".join(sys.argv[1:]))
  except HttpError as e:
    print("An HTTP error %d occurred:\n%s" % (e.resp.status, e.content))
