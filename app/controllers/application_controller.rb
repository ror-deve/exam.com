class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  helper_method :current_account
  before_action :set_current_account
  before_action :set_paper_session
  helper_method :current_paper_session

  layout :layout

  private

  def current_account
    @current_account
  end

  def set_current_account
    if current_teacher
      session[:current_account_id] = params[:account_id] if params[:account_id].present?
      @current_account = current_teacher.accounts.where(:id => session[:current_account_id]).first if session[:current_account_id].present?
    end
  end

  def current_paper_session
    @current_paper_session
  end

  def set_paper_session
    if current_student
      @current_paper_session ||= PaperSession.where(finished_at: nil).find_by(student_id: current_student.id)
    end
  end

  def configure_devise_permitted_parameters
    registration_params = [:name, :phone, :address, :email, :password, :password_confirmation, :avatar]

    if params[:action] == 'update'
      devise_parameter_sanitizer.permit(:account_update) {
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up) {
        |u| u.permit(registration_params)
      }
    end
  end

  def layout
    if teacher_signed_in?
      "manage/application"
    else
      # only turn it off for login pages:
      if is_a?(Devise::SessionsController) || is_a?(Devise::PasswordsController)
        'login'
      elsif is_a?(Devise::RegistrationsController) and (action_name == 'new' or action_name == 'create')
        'login'
      else
        'application'
      end
    end
  end
end
