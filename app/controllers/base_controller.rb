class BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :log_request

  rescue_from ActionView::MissingTemplate do |exception|
    render_and_log(json: { errors: exception.message }, status: :not_implemented)
  end

  rescue_from ActiveRecord::UnknownAttributeError do |exception|
    render_and_log(json: { errors: exception.message }, status: :unprocessable_entity)
  end

  rescue_from ActionController::UrlGenerationError do |exception|
    render_and_log(json: { errors: exception.message }, status: :not_found)
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_and_log(json: { errors: exception.message }, status: :gone)
  end

  def render_and_log(output)
    render output
  end

  def log_request
    if current_user
      Rails.logger.info(
        %(
          \033[32m  Received request from user ##{current_user.id} #{current_user.email} \033[0m
        )
      )
    else
      Rails.logger.info("\033[32m  Received request from an anonymous user\033[0m")
    end
  end
end
