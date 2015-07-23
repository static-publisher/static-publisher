# Static Publisher

[![Build Status](https://travis-ci.org/static-publisher/static-publisher.svg?branch=master)](https://travis-ci.org/static-publisher/static-publisher)

Static Publisher provides endpoints to generate static sites and publish them.

## Installation

The easiest way to deploy is to use this "deploy to heroku" button:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

For other platforms, Static Publisher is a [sinatra](http://www.sinatrarb.com/) app, so instructions for deploying a sinatra app on your chosen platform should work. It also requires a mongodb database, with the environment variable `MONGOLAB_URI` set to the database's url.

## Usage

Once deployed, the admin panel can be found at: `https://your-fancy-domain.com/admin`

![Static Publisher](http://static-publisher.github.io/static-publisher/screenshot.jpg)

### Admin Credentials

The inital username and password are set to `admin` and `admin` respectively.

To change the username and password, click the small user icon in the top right corner. Type your new credentials in the small form for that appears, click the "Change" submit button and log back in again.

## Contributing

1. [Fork it](https://github.com/static-publisher/static-publisher/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
