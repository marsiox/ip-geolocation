FROM ruby:3.2.2
WORKDIR /usr/src/app
COPY . .
RUN bundle install
EXPOSE 9292
ENV NAME World
CMD ["rackup", "-o", "0.0.0.0"]
