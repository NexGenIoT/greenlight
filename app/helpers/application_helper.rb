
require 'bbb_api'
require 'uri'

module ApplicationHelper
  # Determines which providers can show a login button in the login modal.
  def iconset_providers
    providers = configured_providers & [:google, :twitter, :office365, :openid_connect, :ldap]

    providers.delete(:twitter) if session[:old_twitter_user_id]

    providers
  end

  # Generates the login URL for a specific provider.
  def omniauth_login_url(provider)
    if provider == :ldap
      ldap_signin_path
    else
      "#{Rails.configuration.relative_url_root}/auth/#{provider}"
    end
  end

  # Determines if a form field needs the is-invalid class.
  def form_is_invalid?(obj, key)
    'is-invalid' unless obj.errors.messages[key].empty?
  end

  # Return all the translations available in the client side through javascript
  def current_translations
    @translations ||= I18n.backend.send(:translations)
    @translations[I18n.locale]
  end

  # Return the fallback translations available in the client side through javascript
  def fallback_translations
    @fallback_translations ||= I18n.backend.send(:translations)
    @fallback_translations[I18n.default_locale]
  end

  # Returns 'active' if the current page is the users home page (used to style header)
  def active_home
    home_actions = %w[show cant_create_rooms]
    return "active" if params[:controller] == "admins" && params[:action] == "index" && current_user.has_role?(:super_admin)
    return "active" if params[:controller] == "rooms" && home_actions.include?(params[:action])
    ""
  end

  # Returns the action method of the current page
  def active_page
    route = Rails.application.routes.recognize_path(request.env['PATH_INFO'])

    route[:action]
  end

  def role_colour(role)
    role.colour || Rails.configuration.primary_color_default
  end

  def translated_role_name(role)
    case role.name
    when "denied"
      I18n.t("roles.banned")
    when "pending"
      I18n.t("roles.pending")
    when "admin"
      I18n.t("roles.admin")
    when "user"
      I18n.t("roles.user")
    else
      role.name
    end
  end

  def can_reset_password
    # Check if admin is editting user and user is a greenlight account
    Rails.configuration.enable_email_verification &&
      Rails.application.routes.recognize_path(request.env['PATH_INFO'])[:action] == "edit_user" &&
      @user.greenlight_account?
  end

  def google_analytics_url
    "https://www.googletagmanager.com/gtag/js?id=#{ENV['GOOGLE_ANALYTICS_TRACKING_ID']}"
  end

  # Checks to make sure the image url returns 200 and is of type image
  def valid_url?(input)
    url = URI.parse(input)

    # Don't allow reference to own site
    return false if url.host == request.host

    # Make a GET request and validate content type
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    http.read_timeout = 10
    http.open_timeout = 10

    http.start do |web|
      response = web.head(url.request_uri)
      return response.code == "200" && response['Content-Type'].start_with?('image')
    end
  rescue
    false
  end

  # Specifies which title should be the tab title and returns original string
  def title(page_title)
    # Only set the content_for if not already set on the page so that only the first title appears as the tab title
    content_for(:page_title) { page_title } if content_for(:page_title).blank?
    page_title
  end

  # Indicates whether the recording tables should be hidden
  def hide_recording_tables
    return false unless recording_consent_required?
    @settings.get_value("Room Configuration Recording") == "disabled"
  end

  # Hide the signin buttons if there is an error on the page
  def show_signin
    !@hide_signin.present?
  end

  # Returns a more friendly/readable date time object
  def view_date(date)
    return "" if date.nil? # Handle invalid dates
    local_time(date, "%b %d, %Y %-I:%M%P")
  end
end
