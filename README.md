# To run app

1. Install gems `bundle install`
2. Setup database `bundle exec rake db:drop && bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed`
3. Run server `bundle exec rails s`
4. Visit http://127.0.0.1:3000, login with email: `test@gmail.com` and password `password`
5. To run tests `bundle exec rspec`
