module Volksplaner::DeleteAlreadyAuthorizedFlash
  # we do not want to show "you are already signed in" when following the link
  # from the static landing page
  def require_no_authentication
    super
    flash.delete(:alert) if flash[:alert] == I18n.t("devise.failure.already_authenticated")
  end
end
