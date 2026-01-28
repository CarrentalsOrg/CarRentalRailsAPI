# README
 The main objective of this project is to demonstrate how to build a Ruby on Rails API and a respective CI/CD for deploying to remote Production and Staging environments.
 The API itself is a CRUD car rental app where users can create their own vehicles and rent existing ones. `JWT` is used for authentication. 

## Local Setup

 ### Dependencies
 Ruby version - 3.3.6
 
 Bundler version - 2.5.22
 
 Ruby on Rails version - 7.2.2.1
 

 
 Clone the repository and install Ruby 3.3.6. To install the specific bundle version, use `gem install bundler -v 2.5.22`. Finnaly use `bundle install` to install the project dependencies.
 If you already have an previouly installed bundler version, you might need to use `bundle _x.x.x_ install` instead to specify the version.

 ### Encrypted credentials
 Generate devise jwt secret key `rails generate devise:jwt_secret_key`, and for local security purposes, you should store it in [Rails Credentials file](https://guides.rubyonrails.org/security.html)
 To create the Rails credential file and required Rails_Master_Key, use `bin/rails credentials:edit`

 ### Setup database
 Locally, the project uses a SQLite database that ships with Rails, simply use `Rails db:prepare` to setup and migrate the database.

## CI/CD and deployment
  The project uses GitHub Actions for its CI/CD for linting, testing, building, and deploying. This CI/CD builds and pushes a Docker image with its unique `branch and short sha tags` to a private Docker repository in [Dockerhub](https://hub.docker.com/)
  After the image is pushed, use the `deploy action` to deploy it to a chosen environment. 
  
  **Important**
  
  The deployment to `production` should be done after a pull request from the development branch to the master branch, then push a new `git tag` to master, and wait for the image with the respective tag to be created and pushed. This allows versioning of the API's Docker images.
  
  
* Deployment instructions

* ...
