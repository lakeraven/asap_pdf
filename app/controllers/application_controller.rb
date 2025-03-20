class ApplicationController < ActionController::Base
  # TODO: REMOVE ME!!!
  skip_before_filter :verify_authenticity_token
end
