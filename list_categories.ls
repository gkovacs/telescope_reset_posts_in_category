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
  (err,results) <- db.collection('categories').find().toArray
  categories = results.map (.slug)
  console.log categories
  db.close()
  process.exit()
