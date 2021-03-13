
class ThemesController < ApplicationController
  skip_before_action :block_unknown_hosts, :redirect_to_https, :maintenance_mode?, :migration_error?, :user_locale,
    :check_admin_password, :check_user_role

  # GET /primary
  def index
    color = @settings.get_value("Primary Color") || Rails.configuration.primary_color_default
    lighten_color = @settings.get_value("Primary Color Lighten") || Rails.configuration.primary_color_lighten_default
    darken_color = @settings.get_value("Primary Color Darken") || Rails.configuration.primary_color_darken_default

    file_name = Rails.root.join('lib', 'assets', '_primary_themes.scss')
    @file_contents = File.read(file_name)

    # Include the variables and covert scss file to css
    @compiled = SassC::Engine.new("$primary-color:#{color};" \
                                 "$primary-color-lighten:#{lighten_color};" \
                                 "$primary-color-darken:#{darken_color};" +
                                 @file_contents, syntax: :scss).render

    respond_to do |format|
      format.css { render body: @compiled }
    end
  end
end
