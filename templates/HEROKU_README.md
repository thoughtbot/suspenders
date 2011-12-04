Staging and production environments
-----------------------------------

We're using Heroku as a hosting provider. Deploying to Heroku is done via git. So, set up your git remotes for each environment:

    git remote add staging git@heroku.com:your-app-staging.git
    git remote add production git@heroku.com:your-app-production.git

Heroku
------

The following are mostly aliases from the `dotfiles` script.

To access your code on Heroku:

    staging
    production

That will drop you into a Rails console for either environment. You can run ActiveRecord queries from there.

To dump staging or production data into your development environment:

    db-pull-staging
    db-pull-production

You will see progress bars for each db index and table.

We can create a database backup at any time:

    db-backup-production

View backups:

    db-backups

To destroy a backup:

    heroku pgbackups:destroy b003 --remote production

Transfer production data to staging:

    db-copy-production-to-staging

More information in the [Dev Center](http://devcenter.heroku.com/articles/pgbackups).

To check the status of running app servers, background jobs, cron jobs, etc:

    staging-process
    production-process

To see the performance of the staging application, see:

    https://heroku.newrelic.com/...

To see the performance of the production application, see:

    https://heroku.newrelic.com/...

ENV variables
-------------

ENV variables like AWS keys should not be in the source code. They are configuration and should be stored as ENV variables. On Heroku, they are called "config variables." You can pull config variables using the `heroku-config` plugin that comes with the `laptop` script:

    heroku config:pull --remote staging

You'll see the Amazon credentials as config vars. You should delete lines that don't apply, like Redis to Go connection strings.
