class TeachersController < ApplicationController
  before_action :authenticate_teacher!
  before_action :set_teacher, only: [:show, :edit, :update, :destroy, :profile, :change_password, :notifications, :mark_as_read]

  def profile
    @teacher = current_teacher
    render 'shared/profile'
  end

  def notifications
    if params[:type] == 'unread'
      @notifications = @teacher.notifications.unread_notifications
    else
      @notifications = @teacher.notifications
    end
  end

  def mark_as_read
    @notification = @teacher.notifications.find(params[:id])
    if @notification.update(read: true)
      respond_to do |format|
        format.js 
      end
    end
  end

  def upload_avatar
    respond_to do |format|
      @teacher = current_teacher
      if @teacher.update(teacher_params)
        @notification = { status: 'success', title: 'Updated', message: 'Profile image updated successfully.' }
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Something went wrong!!!!!!' }
      end
      format.js { }
    end
  end

  def index
    @teachers = @account.teachers.all
  end

  def show
  end

  def update
    respond_to do |format|
      @teacher = current_teacher
      if @teacher.update(teacher_params)
        if @teacher.save
          @notification = { status: 'success', title: 'Updated', message: 'Profile updated successfully.' }
        else
          @error = true
        end
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Something went wrong, please try again!!!' }
      end
      format.js { }
    end 
  end 

  def change_password
    respond_to do |format|
      @teacher = current_teacher
      if @teacher.update_with_password(teacher_params)
        if @teacher.save
          bypass_sign_in(@teacher)
          @notification = { status: 'success', title: 'Updated', message: 'password changed successfully.' }
        else
          @error = true
        end
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Your current password is incorrect!!!' }
      end
      format.js { }
    end 
  end 

  def new
    @teacher = Teacher.new
  end

  private
  def set_teacher
    # @teacher = Teacher.where(:id => params[:id]).first
    @teacher = current_teacher
  end
  
  def teacher_params
    params.require(:teacher).permit(:email, :name, :phone, :qualifications, :avatar, :current_password, :password, :password_confirmation)
  end
end
