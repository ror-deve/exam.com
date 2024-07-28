class CustomDevise::RegistrationsController < Devise::RegistrationsController
  layout 'login', only: [:new, :create]
  skip_before_action :verify_authenticity_token

  def new
    # Your custom code here
    super
  end

  def create
    # Your custom code here
    super
  end

  # Add other overridden methods as needed
end
