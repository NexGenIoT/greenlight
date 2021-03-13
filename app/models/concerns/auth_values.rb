
module AuthValues
  extend ActiveSupport::Concern

  # Provider attributes.
  def auth_name(auth)
    case auth['provider']
    when :office365
      auth['info']['display_name']
    else
      auth['info']['name']
    end
  end

  def auth_username(auth)
    case auth['provider']
    when :google
      auth['info']['email'].split('@').first
    when :bn_launcher
      auth['info']['username']
    else
      auth['info']['nickname']
    end
  end

  def auth_email(auth)
    auth['info']['email']
  end

  def auth_image(auth)
    case auth['provider']
    when :twitter
      auth['info']['image'].gsub("http", "https").gsub("_normal", "")
    when :ldap
      return auth['info']['image'] if auth['info']['image']&.starts_with?("http")
      ""
    else
      auth['info']['image']
    end
  end

  def auth_roles(user, auth)
    unless auth['info']['roles'].nil?
      roles = auth['info']['roles'].split(',')

      role_provider = auth['provider'] == "bn_launcher" ? auth['info']['customer'] : "greenlight"
      roles.each do |role_name|
        role = Role.find_by(provider: role_provider, name: role_name)
        user.set_role(role_name) if !role.nil? && !user.has_role?(role_name)
      end
    end
  end
end
