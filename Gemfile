source "https://rubygems.org"

ruby "2.1.2"

gem "rake"
gem "sinatra"
gem "github_api"
gem "twitter"
gem "sinatra-partial"

group :development, :production do
  gem "redis"
end  

group :test do
  gem "mock_redis"
  gem "vcr"
  gem "webmock"
end  

group :development do
  gem "travis"
end  

group :development, :test do
  gem "rspec"
  gem "rack-test"
  gem "database_cleaner"
  gem "dotenv"
end