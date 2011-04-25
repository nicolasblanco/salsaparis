class Admin::AdminController < LoggedController
  protected
  def check_rights!
    redirect_to '/' unless current_user.admin? || current_user.authorized?
  end
end
