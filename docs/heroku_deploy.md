# Deploying to Heroku

## Setup

Deploying to Heroku requires two additional steps:

1. Manually add buildpacks `node.js` and `ruby` (in that order) to your Heroku
   app. This is necessary because build order is important and Heroku's
   auto-detection will add them in the wrong order.

2. Set the following environment variables:

- `ASSET_HOST`: `siteURL.herokuapp.com`
- `APPLICATION_HOST`: `siteURL.herokuapp.com`
- `SMTP_ADDRESS`: `smtp.example.com`
- `SMTP_DOMAIN`: `example.com`
- `SMTP_USERNAME`: `username`
- `SMTP_PASSWORD`: `password`

## Execution

- Use the `./bin/deploy` convention for deploying to Heroku
