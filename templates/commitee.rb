# frozen_string_literal: true

# Configuration for JSON Schema middlewares
json = File.read(File.expand_path('../../schema/api.json', __dir__))
schema = Committee::Drivers::HyperSchema.new.parse(JSON.parse(json))

ActionController::Parameters.permit_all_parameters = true

Rails.application.config.middleware.insert_before(
  ActionDispatch::Executor,
  Committee::Middleware::RequestValidation,
  schema: schema
)

Rails.application.config.middleware.insert_after(
  ActionDispatch::Callbacks,
  Committee::Middleware::ResponseValidation,
  schema: schema
)
