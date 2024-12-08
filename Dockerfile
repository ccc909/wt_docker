FROM ruby:3.1.4

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set an environment variable to store the app's path
WORKDIR /src

# Set environment variables for the Rails app
ENV RAILS_ENV='development'
ENV RACK_ENV='development'

# Install bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock into the image
COPY src/Gemfile src/Gemfile.lock /src/

# Install the gems specified in the Gemfile
RUN bundle install

# Copy the rest of the application code into the image
COPY src /src/

# Copy the entrypoint script into the image and set permissions
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose port 3000 to the Docker host
EXPOSE 3000


# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]