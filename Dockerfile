FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y build-essential libmariadb-dev
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 3001
CMD ["bundle", "exec", "rails", "s", "-p", "3001", "-b", "0.0.0.0"]
