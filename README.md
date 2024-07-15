# My Social
A Ruby on Rails API only application. This app is a small social media that allows users to post, edit, and remove their own message and see other's messages in public.

# Scope
- API Development
  - RESTful API
  - CRUD
  - Secure the API with Bearer Token
- Database Integration
  - There are 2 migrations for creating users table and posts table
  - User ActiveRecord
    - integrated with devise-token-auth gem
    - one-to-many relationship with Post
  - Post ActiveRecord
    - one-to-one relationship with User and
    - validations
- Testing
  - Unit tests for User and Post
  - Functional tests for Auth APIs and Posts APIs
- Error handling
  - 401 Unauthorized
  - 403 Forbidden
  - 404 Not Found
  - 422 Unprocessable Entity
- Documentation
  - API document via Postman

# Prerequisite
  - Ruby 3.3.4 ([for macOS](https://nrogap.medium.com/install-rvm-in-macos-step-by-step-d3b3c236953b))
  - PostgreSQL 12

# Setup Instructions
- Clone the source code
```bash
git clone https://github.com/nrogap/mysocial.git
```
- Go to `mysocial` and install gems
```bash
cd mysocial
bundle install
```
- Edit `user` and `password` in `config/database.yml`
```yml
# config/database.yml
development:
  <<: *default
  database: mysocial_development
  user: <YOUR_DATABASE_USER>
  password: <YOUR_DATABASE_PASSWORD>

test:
  <<: *default
  database: mysocial_test
  user: <YOUR_DATABASE_USER>
  password: <YOUR_DATABASE_PASSWORD>
```
- Setup the database
```bash
bundle exec rails db:create db:migrate
```
- Start the app
```bash
bundle exec rails s
```
- Enjoy 🎉 feel free to use the APIs though [Postman](https://documenter.getpostman.com/view/5198036/2sA3kPoPas) or other tool 😉

# API Document
- https://documenter.getpostman.com/view/5198036/2sA3kPoPas

# How to run the test suite
```bash
bundle exec rspec
```