class Manage::TopicsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :find_subject
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    respond_to do |format|
      if params[:query]
        @topics = @subject.topics.search_by_name(params[:query]).paginate(page: params[:page])
      else
        @topics = @subject.topics.all.paginate(page: params[:page])
      end
      format.html { }
      format.js { }
    end
    @topic = Topic.new
  end

  # GET /subscriptions/1.json
  def show
  end

  def new
    @topic = Topic.new
    respond_to do |format|
      format.js { }
    end 
  end

  def edit
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.subject_id = @subject.id

    respond_to do |format|
      if @topic.save
        @topics = @subject.topics.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Created', message: 'Topic was successfully added.' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to create topic' }
        format.js {}
      end
    end
  end

  def update
    respond_to do |format|
      if @topic.update(topic_params)
        @topics = @subject.topics.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Updated', message: 'Topic was successfully updated.' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to update topic' }
        format.js {}
      end
    end
  end

  def destroy
    @topic.destroy
    respond_to do |format|
      @notification = { status: 'success', title: 'Deleted', message: 'Successfully deleted topic' }
      format.js { }
    end
  end

  private
    def find_subject
      @subject = Subject.where(:id => params[:subject_id]).first
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.where(:id => params[:id], :subject_id => params[:subject_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:id, :subject_id,:name)
    end
end
