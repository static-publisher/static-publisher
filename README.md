# Static Publisher

[![Build Status](https://travis-ci.org/static-publisher/static-publisher.svg?branch=master)](https://travis-ci.org/static-publisher/static-publisher)

Static Publisher is an automated deployment server for static site generators, such as [Jekyll](http://jekyllrb.com/). It provides endpoints that can be called by webhooks from git hosting sites such as GitHub or BitBucket everytime a project is updated. It has an easy to use admin panel for managing multiple projects deployment, it can run plugins without security restrictions and it can publish to an S3 bucket or git repository.

## Installation

The easiest way to deploy is to use this "deploy to heroku" button:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

For other platforms, Static Publisher is a [sinatra](http://www.sinatrarb.com/) app, so instructions for deploying a sinatra app on your chosen platform should work. It also requires a [mongodb](https://www.mongodb.org/) database, with the environment variable `MONGOLAB_URI` set to the database's url.

## Usage

Once deployed, the admin panel can be found at: `https://your-fancy-domain.com/admin`

![Static Publisher](http://static-publisher.github.io/static-publisher/screenshot.jpg)

### Admin Credentials

The inital username and password are set to `admin` and `admin` respectively.

To change the username and password, click the small user icon in the top right corner. Type your new credentials in the small form for that appears, click the "Change" submit button and log back in again.

### Endpoint

Each generate-publish sequence is triggered by an endpoint, a URL that responds to a HTTP POST request, to be used as a callback for a webhook. The content of the request is completely ignored to avoid relying on any specific webhook's format.

Static Publisher will still return a `200` status indiscriminately, even if a no matching endpoint is found or an error occurs during the generate-publish sequence. Therefore, it is wise to test that an endpoint is working by either checking that it has published successfully or by consulting the STDOUT logs.

#### Route

The path for the endpoint. It must always start with a preceeding forward slash. For example, a route of `/update-my-awesome-jekyll` will make the URL `https://your-fancy-domain.com/update-my-awesome-jekyll` trigger the generate-publish sequence.

The following routes cannot be used as they are used for the admin panel: `/user` or `/config`

### Source

The location and branch of the git repository for the project you wish to publish.

### Generator

Currently, the follow static site generators are supported:

* [Jekyll](http://jekyllrb.com/)

### Destination

These are the methods of publishing that are currently supported:

* [S3](http://aws.amazon.com/s3/)
* Git

Click on any of the subsection's labels to reveal their fields. If all the relevent fields are filled in, then that publish method will be attempted.

#### S3

To get your access key, [follow these instructions](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html).

If the `bucket` does not exist it will be created.

#### Git

To publish to a git repository that is password protected use the following form:

`https://[username]:[password]@my-repo-host.com/cool-organisation/awesome-project`

## Contributing

1. [Fork it](https://github.com/static-publisher/static-publisher/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
