#

A skeleton for a to-be-named game for the ludum dare 33 compo.

## Setup

1. Install [Node.js](https://nodejs.org) (these days, Node comes with [NPM](https://www.npmjs.org)) and PhantomJS. Assuming you have Homebrew installed:

2. Install Ruby (> 2.0) and [Bundler](http://bundler.io).

3. Install [gulp](http://gulpjs.com) and [bower](http://bower.io). Gulp is the build system we're using. Bower is a package manager for front-end libraries.

        npm install -g gulp bower

4. Install the rest of the prerequisites using their various dependency management systems:
  *Note: you might need to be root to run `bundle install` on your system*

        npm install
        bower install
        bundle install

5. Run the full test suite:

        gulp test

6. Run the development server and unit tests:

        gulp


## Deployment

Deployment to an S3 bucket is done in one command. You only need to specify the destination bucket and the desired config file to use

    AWS_PROFILE=profile gulp deploy --bucket my-bucket-name --config staging

AWS credentials are read from `~/.aws/credentials`.
