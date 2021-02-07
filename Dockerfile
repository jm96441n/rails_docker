# Dockerfile rails
FROM ruby:2.7.2-alpine as base_deps

# common deps
RUN apk add --update \
    build-base \
    git \ 
    tzdata

# Application deps
RUN apk add --update \
    nodejs \
    postgresql-client \
    postgresql-dev \
    yarn

WORKDIR /app
# install bundler
RUN gem install bundler
# install rails
RUN gem install rails

FROM base_deps as ruby_deps
WORKDIR /app
# Install gems
ADD Gemfile* ./
RUN bundle install

FROM ruby_deps as node_deps
WORKDIR /app
# Install node modules
ADD package.json *yarn* ./
RUN yarn install --check-files

FROM node_deps as test_deps
COPY --from=ruby_deps /usr/local/bundle/ /usr/local/bundle/
COPY --from=node_deps ./app/node_modules /app/node_modules/
RUN apk add --update \
    chromium \
    chromium-chromedriver  \
    python3 \
    python3-dev \
    py3-pip
RUN pip3 install -U selenium
RUN bundle install --with test

# A separate build stage installs test dependencies and runs your tests
FROM test_deps AS test
WORKDIR /app
ENV DATABASE_HOST=docker.for.mac.localhost
# The test stage installs the test dependencies
# The actual test run
CMD ["bundle", "exec", "rspec"]


# A separate build stage installs test dependencies and runs your tests
FROM node_deps AS dev_deps
COPY --from=ruby_deps /usr/local/bundle/ /usr/local/bundle/
COPY --from=node_deps ./app/node_modules /app/node_modules/
# The test stage installs the test dependencies
RUN bundle install --with test development

FROM dev_deps AS dev
WORKDIR /app
ENV DATABASE_HOST=docker.for.mac.localhost
CMD ["bin/dev_entry"]

FROM node_deps as prod
WORKDIR /app
COPY --from=ruby_deps /usr/local/bundle/ /usr/local/bundle/
COPY . ./
COPY --from=node_deps ./app/node_modules /app/node_modules/
RUN chmod +x ./bin/prod_entry
RUN bundle exec rake assets:precompile

CMD ["bin/prod_entry"]
