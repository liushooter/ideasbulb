web: bundle exec rails server
solr: bundle exec rake sunspot:solr:run
smtp: bundle exec mailcatcher -f
redis: redis-server /usr/local/etc/redis.conf 
worker: bundle exec rake resque:work QUEUE=message
