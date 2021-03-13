
require 'i18n/language/mapping'

module UsersHelper
  include I18n::Language::Mapping

  def recaptcha_enabled?
    Rails.configuration.recaptcha_enabled
  end

  def disabled_roles(user)
    current_user_role = current_user.role

    # Admins are able to remove the admin role from other admins
    # For all other roles they can only add/remove roles with a higher priority
    disallowed_roles = if current_user_role.name == "admin"
                          Role.editable_roles(@user_domain).where("priority < #{current_user_role.priority}")
                              .pluck(:id)
                        else
                          Role.editable_roles(@user_domain).where("priority <= #{current_user_role.priority}")
                              .pluck(:id)
                       end

    [user.role.id] + disallowed_roles
  end

  # Returns language selection options for user edit
  def language_options
    locales = I18n.available_locales
    language_opts = [["<<<< #{t('language_default')} >>>>", "default"]]
    locales.each do |locale|
      language_mapping = I18n::Language::Mapping.language_mapping_list[locale.to_s.gsub("_", "-")]
      language_opts.push([language_mapping["nativeName"], locale.to_s])
    end
    language_opts.sort
  end

  # Returns a list of roles that the user can have
  def role_options
    Role.editable_roles(@user_domain).where("priority >= ?", current_user.role.priority).by_priority
  end

  # Parses markdown for rendering.
  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      autolink: true,
      tables: true,
      underline: true,
      highlight: true)

    markdown.render(text).html_safe
  end
end
