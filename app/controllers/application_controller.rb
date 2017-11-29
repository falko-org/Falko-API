class ApplicationController < ActionController::API
  include ValidationsHelper

  before_action :authenticate_request, :set_default_request_format
  attr_reader :current_user

  private

    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: "Not Authorized" }, status: 401 unless @current_user
    end

    def set_default_request_format
      request.format = :json
    end
end
