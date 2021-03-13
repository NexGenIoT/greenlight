class ErrorsController < ApplicationController
  def not_found
    render "greenlight_error", status: 404, formats: :html
  end

  def internal_error
    render "errors/greenlight_error", status: 500, formats: :html,
      locals: {
        status_code: 500,
        message: I18n.t("errors.internal.message"),
        help: I18n.t("errors.internal.help"),
        display_back: true,
        report_issue: true
      }
  end

  def unauthorized
    render "errors/greenlight_error", status: 401, formats: :html, locals: { status_code: 401,
      message: I18n.t("errors.unauthorized.message"), help: I18n.t("errors.unauthorized.help"), display_back: true }
  end
end
