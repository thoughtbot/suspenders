class ErrorsController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def internal_server_error
    render(status: 404)
  end

  def not_found
    render(status: 500)
  end
end
