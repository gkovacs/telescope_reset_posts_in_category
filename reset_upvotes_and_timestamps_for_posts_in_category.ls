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

category_name = process.argv[3]
if not category_name?
  console.log 'need to provide category name'
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
  (err,results) <- db.collection('categories').find().toArray
  category_name_to_id = {[x.slug, x._id] for x in results}
  console.log category_name_to_id
  category_id = category_name_to_id[category_name]
  if not category_id?
    console.log 'category_id not found for category ' + category_name
    process.exit()
  console.log 'resetting category ' + category_name + ' with id ' + category_id
  curdate = new Date()
  (err2,results2) <- db.collection('posts').update({categories: category_id}, {$set: { upvotes: 0, postedAt: curdate }}, {multi: true})
  console.log results2
  console.log 'done resetting category ' + category_name
  db.close()
  process.exit()