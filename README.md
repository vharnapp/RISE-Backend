# Athletefit backend

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc.

## Seeded Data

Assuming that devise was opted in to, a user and admin have been seeded for you:

    admin@example.com -> asdfjkl123
    user_1@example.com -> asdfjkl123

## Static Pages

The HighVoltage gem is used.

## Authorization

This repo uses CanCanCan and Canard to authorize user action. `ApplicationController` defines the `check_authorization` method for non-devise non-high voltage controllers. If you want to skip authorization for a specific method in a controller, the following method can be used: `skip_authorization_check`

## Rubocop

Take a look at the `.rubocop.yml` file to see what styles are being enforced.

## Annotations

Model & spec files are automatically annotated each time `rake db:migrate` is run.

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    % ./bin/deploy staging
    % ./bin/deploy production

# Set Heroku Config Vars

    heroku config:set FORCE_SEED=1
    heroku config:set SEGMENT_ANALYTICS_RUBY_KEY=''
    heroku config:set SMTP_ADDRESS=''
    heroku config:set SMTP_DOMAIN=''
    heroku config:set SMTP_PASSWORD=''
    heroku config:set SMTP_USERNAME=''
    heroku config:set APPLICATION_HOST='athletefit.headway.io'

# Backing up s3

If you have more than one profile in your ~/.aws/credentials file you can specify the `--profile` flag with the name.

```bash
aws s3 cp s3://rise-media2 ./ --recursive --profile rise
```
