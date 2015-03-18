require! {
  fs
  'mongo-uri'
}
{run, exec} = require 'execSync'
{MongoClient} = require 'mongodb'

meteorsite = process.argv[2]
if not meteorsite?
  console.log 'need to provide meteorsite'
  process.exit()
if meteorsite.indexOf('.meteor.com') == -1
  meteorsite = meteorsite + '.meteor.com'

post_id = process.argv[3]
if not post_id?
  console.log 'need to provide post id'
  process.exit()

mongourl = exec("meteor mongo --url #{meteorsite}").stdout.trim()
#mongourl = 'mongodb://localhost:27017/crowdresearchtest_meteor_com'
console.log 'mongourl: ' + mongourl



get-mongo-db = (callback) ->
  MongoClient.connect mongourl, (err, db) ->
    if err
      console.log 'error getting mongodb'
    else
      callback db

get-mongo-db (db) ->
  (err2,results2) <- db.collection('posts').update({_id: post_id}, {$set: { upvotes: 0, upvoters: [] }})
  console.log results2
  console.log 'done resetting post ' + post_id
  db.close()
  process.exit()
