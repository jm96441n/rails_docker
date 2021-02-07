# Example Application for Dockerizing a Rails Application

This repo is here as an example of how to set up and dockerize
a rails application to use a single Dockerfile for running your application
in all your environments. To read more see the blog post that covers this repo
[here](example.com) and check out the application running on heroku [here](https://rails-docker-example.herokuapp.com/)

# Running Locally

To run locally you should be running Postgres 13 and have Docker installed as well. This
application assumes that you'll have set up a user in your PG database and
added those as secrets to this rails app. Following that you're set to run the app!

### Development Server:
```
bin/docker dev
```
(Note: you may need to give yourself permission to run this file with `chmod +x ./bin/docker`)

### Tests
```
bin/docker test
```
