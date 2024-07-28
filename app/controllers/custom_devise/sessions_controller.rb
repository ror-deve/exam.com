class CustomDevise::SessionsController < Devise::SessionsController
  layout 'login'
  skip_before_action :verify_authenticity_token

  def create
    super do |resource|
      set_default_account(resource)
    end
  end

  protected

  def configure_sign_in_params
    params.require(:user).permit(:login, :password, :remember_me)
  end

  private

  def set_default_account(user)
    default_account = user.accounts.first

    if default_account
      session[:current_account_id] = default_account.id
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_manage_accounts_path
  end
end
