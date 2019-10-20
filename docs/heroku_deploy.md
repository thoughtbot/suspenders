# Deploying to Heroku

## Setup

Deploying to Heroku requires two additional steps:

1. Set the following environment variables:

- `ASSET_HOST`: `siteURL.herokuapp.com`
- `APPLICATION_HOST`: `siteURL.herokuapp.com`
- `SMTP_ADDRESS`: `smtp.example.com`
- `SMTP_DOMAIN`: `example.com`
- `SMTP_USERNAME`: `username`
- `SMTP_PASSWORD`: `password`

## Execution

- Use the `./bin/deploy` convention for deploying to Heroku
