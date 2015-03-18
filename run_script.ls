{run, exec} = require 'execSync'

# please do a backup before running this script!
# mongodump_meteor crowdresearchtest

# meteorsite = 'crowdresearch'
meteorsite = 'crowdresearchtest'
categories = [ 'milestone-3-trust-ideas', 'milestone-3-power-ideas', 'milestone-3-dark-horse-ideas' ]
# to get the list of categories:
# lsc list_categories.ls crowdresearchtest

console.log 'backing up stuff'

run "mongodump_meteor #{meteorsite}"

console.log 'backup complete'

for category in categories
  run "lsc reset_upvotes_and_timestamps_for_posts_in_category.ls #{meteorsite} #{category}"

console.log 'all done'
