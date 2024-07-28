class Manage::TeachersController < ApplicationController
  before_action :authenticate_teacher!
  before_action :find_account
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

  def index
    @teachers = @account.teachers.all
  end

  def show
  end

  def new
    @teacher = Teacher.new
  end

  def edit
  end

  def create
    @teacher = Teacher.where(:email => teacher_params[:email]).first
    unless @teacher
      @teacher = Teacher.new(teacher_params)
      @teacher.password = '123456789'
      @teacher.password_confirmation = '123456789'
    end

    respond_to do |format|
      if @teacher.save and AccountTeacher.where(:account_id => @account.id, :teacher_id => @teacher.id, :admin => false).first_or_create
        format.html { redirect_to manage_account_teachers_path(@account), notice: 'Teacher was successfully added.' }
        format.json { render :show, status: :created, location: manage_account_teachers_path(@account) }
      else
        format.html { render :new }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @account_teacher = AccountTeacher.where(:account_id => @account.id, :teacher_id => params[:id]).first
    respond_to do |format|
      if @account_teacher.toggle!(:admin)
        format.html { redirect_to manage_account_teachers_path(@account), notice: 'Teacher was successfully updated.' }
        format.json { render :show, status: :updated, location: manage_account_teachers_path(@account) }
      else
        format.html { redirect_to manage_account_teachers_path(@account), alert: 'Error! Unable to update teacher.' }
        format.json { render json: ["Unable to process"], status: :unprocessable_entity }
      end
    end
  end

  def destroy
    AccountTeacher.where(:account_id => @account.id, :teacher_id => @teacher.id).first.try(:destroy)
    respond_to do |format|
      format.html { redirect_to manage_account_teachers_path(@account), notice: 'Teacher was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    def find_account
      @account = current_teacher.admin_accounts.where(:id => params[:account_id]).first
      if @account.blank?
        redirect_to root_url and return
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = @account.teachers.where(:id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit(:name,:email,:phone)
    end
end
