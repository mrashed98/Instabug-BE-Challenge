class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render json: { message: "Record Not found" }, status: 404
  end

  rescue_from ActiveRecord::RecordNotSaved do |exception|
    render json: {
      message: exception.record.errors.full_messages.join(", ")
    }, status: 4422
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: { message: exception.message }, status: 400
  end
end
