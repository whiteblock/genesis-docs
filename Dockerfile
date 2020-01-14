FROM ruby as builder

# NOTE: doing COPY before RUN slows down repeated builds
#       but it is necessary (at least for now) because the files
#       specifying the dependencies (ie Gemfile and Gemfile.lock)
#       are copied over in this step.
ENV LANG=en_US.UTF-8

RUN mkdir -p /src

COPY Gemfile /src
COPY Gemfile.lock /src

WORKDIR /src

RUN gem install bundler \
  && bundle install

COPY . /src

RUN bundle exec jekyll build

FROM nginx:alpine
COPY --from=builder /src/_site /usr/share/nginx/html
# Create folder for PID file
RUN mkdir -p /run/nginx
# Add our nginx conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
