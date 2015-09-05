# Description
#   Execute cloudflare related tasks using Hubot
#
# Dependencies:
#   "request": "2.61.0"
#
# Configuration:
#   CF_EMAIL
#   CF_TOKEN
#   CF_ZONE
#
# Commands:
#   hubot cf purge <Path of file to purge...> - Purges a file from cloudflare cache
#
# Notes:
#   Be sure that the CF_TOKEN has access to the domain provided in CF_ZONE
#
# Author:
#   gamerlv
#

r = require 'request'
CF_email = process.env.CF_EMAIL
CF_token = process.env.CF_TOKEN
CF_zone  = process.env.CF_ZONE.replace("www.", "")
 
Array::chunk = (chunkSize) ->
  array = this
  [].concat.apply [], array.map((elem, i) ->
    (if i % chunkSize then [] else [array.slice(i, i + chunkSize)])
  )

getZoneId = (domainName, callback) ->
  options =
    url: "https://api.cloudflare.com/client/v4/zones/"
    headers:
      "X-Auth-Key": CF_token
      "X-Auth-Email": CF_email
    qs:
      name: CF_zone
      status: "active"
    json: true

  r.get options, (err, resp, body) ->
    if err
      callback(err, "")
      return
    if !body.success
      callback(body.errors.join(", "), "")
      return

    if body.result.length > 0
      callback(null, body.result[0].id)
    else
      callback("Not enough results; " + body.messages.join(", "), "")
  

module.exports = (robot) ->
  # Match domain paths: ((\/[-\\w~,;\\./?%&+#=]*)\\s*)*
  robot.respond "/cf purge (.*)/i", (msg) ->
    files = msg.match[1].split(" ")
    # Make sure there are no empty strings
    files = files.filter (path, index, orgArr) ->
      !( path.trim() == "" or !/(\/[-\w~,;\.\/?%&+=]*)/i.test(path) )

    if files.length < 1
      msg.reply "Could you tell me which files to purge? Usage: `cf purge </path> (/paths...)`"
      return

    # CF needs files to be with the FQDN
    for path,index in files
      if path.indexOf "http" != 0
        files[index] = "http://" + CF_zone + path
    # console.log(msg.match, files)
    files = files.chunk(30) # We may only send 30 files per request to cloudflare
    
    getZoneId CF_zone, (err, zoneID) ->
      if err
        msg.reply "Error while retriving zone: " + err
        return

      for files_chunk in files
        options =
          url: "https://api.cloudflare.com/client/v4/zones/" + zoneID + "/purge_cache"
          headers: 
            "X-Auth-Key": CF_token
            "X-Auth-Email": CF_email
          json: true
          body: 
            "files": files_chunk

        r.del options, (err, resp, body) ->
          if err
            msg.reply "Can't do that now: " + err
          else
            if body.success
              msg.send "cloudflare cache purged of " + files_chunk.join(", ")
            else
              errorStr = ""
              body.errors.map (error) ->
                errorStr += error.code + ": " + error.message + ","
                return

              msg.reply "Purge failed; " + errorStr
        

