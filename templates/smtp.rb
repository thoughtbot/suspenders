if Rails.env.staging? || Rails.env.production?
  SMTP_SETTINGS = {
    address: 'smtp.sendgrid.net',
    authentication: :plain,
    domain: ENV.fetch('SMTP_DOMAIN'), # example: 'this-app.com'
    password: ENV.fetch('SENDGRID_PASSWORD'),
    port: '587',
    user_name: ENV.fetch('SENDGRID_USERNAME')
  }
end
