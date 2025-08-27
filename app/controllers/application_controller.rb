class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :kick_suspended!, if: :user_signed_in?

  rescue_from CanCan::AccessDenied do |_e|
    redirect_to authenticated_root_path, alert: "Acesso não autorizado."
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,        keys: [:nome])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome])
  end

  def after_sign_in_path_for(_resource)
    authenticated_root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    unauthenticated_root_path
  end

  private

  def kick_suspended!
    return unless current_user&.suspended?

    sign_out current_user
    redirect_to new_user_session_path,
                alert: I18n.t("devise.failure.suspended", default: "Sua conta está suspensa.")
  end
end
