
class MainController < ApplicationController
  include Registrar
  # GET /
  def index
    # Store invite token
    session[:invite_token] = params[:invite_token] if params[:invite_token] && invite_registration

    redirect_to home_page if current_user
  end
end
