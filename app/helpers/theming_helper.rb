
module ThemingHelper
  # Returns the logo based on user's provider
  def logo_image
    @settings.get_value("Branding Image") || Rails.configuration.branding_image_default
  end

  # Returns the legal URL based on user's provider
  def legal_url
    @settings.get_value("Legal URL") || ""
  end

  # Returns the privacy policy URL based on user's provider
  def privpolicy_url
    @settings.get_value("Privacy Policy URL") || ""
  end

  # Returns the primary color based on user's provider
  def user_color
    @settings.get_value("Primary Color") || Rails.configuration.primary_color_default
  end

  def maintenance_banner
    @settings.get_value("Maintenance Banner")
  end
end
