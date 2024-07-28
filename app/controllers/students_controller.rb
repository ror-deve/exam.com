class StudentsController < ApplicationController
  before_action :authenticate_student!
  before_action :find_batch
  before_action :set_student, only: [:show, :edit, :update, :destroy, :notifications]

  def profile
    @student = current_student
    render 'shared/profile'
  end

  def notifications
    if params[:type] == 'unread'
      @notifications = @student.notifications.unread_notifications
    else
      @notifications = @student.notifications
    end
  end

  def upload_avatar
    respond_to do |format|
      @student = current_student
      if @student.update(student_params)
        @notification = { status: 'success', title: 'Updated', message: 'Profile image updated successfully.' }
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Something went wrong!!!!!!' }
      end
      format.js { }
    end
  end
  
  def index
    @students = @batch.students.all
  end

  def show
  end

  def update
    respond_to do |format|
      @student = current_student
      if @student.update(student_params)
        if @student.save
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
      @student = current_student
      if @student.update_with_password(student_params)   
        if @student.save
          bypass_sign_in(@student)
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

  private
  def find_batch
    @batch = current_student.batches.where(:id => params[:batch_id]).first
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.where(:id => params[:id]).first
  end

  def student_params
    params.require(:student).permit(:email, :name, :phone, :address, :avatar, :current_password, :password, :password_confirmation)
  end
end
