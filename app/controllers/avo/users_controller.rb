# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/3.0/controllers.html
class Avo::UsersController < Avo::ResourcesController
  include Authentication
  delegate :new_session_path, to: :main_app

  prepend_before_action :require_authentication
end
