class Manage::SubjectsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      if params[:query]
        @subjects = current_teacher.subjects.search_by_name(params[:query]).paginate(page: params[:page])
      else
        @subjects = current_teacher.subjects.all.paginate(page: params[:page])
      end
      format.html { }
      format.js { }
    end
      @subject = Subject.new
      @topic = Topic.new
  end

  def show
  end

  # GET /exams/new
  def new
    @subject = Subject.new
  end

  def edit
  end
  
  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        current_teacher.subjects << @subject
        @subjects = current_teacher.subjects.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Created', message: 'Subject was successfully created.' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to create subject' }
        format.js {}
      end
    end
  end

  def update
    respond_to do |format|
      if @subject.update(subject_params)
        @subjects = current_teacher.subjects.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Updated', message: 'Subject was successfully updated.' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to update subject' }
        format.js {}
      end
    end
  end

  def destroy
    @subject.destroy
    respond_to do |format|
      @notification = { status: 'success', title: 'Deleted', message: 'Successfully deleted subject' }
      format.js { }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.where(:id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:id, :name)
    end
end
