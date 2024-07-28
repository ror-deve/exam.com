class Manage::BatchesController < ApplicationController
  before_action :authenticate_teacher!
  before_action :set_batch, only: [:show, :edit, :update, :destroy]

  # GET /batches
  # GET /batches.json
  def index
    @batches = Batch.where(:account_id => @current_account.id).all.paginate(page: params[:page])
    @batch = Batch.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /batches/1
  # GET /batches/1.json
  def show
  end

  # GET /batches/new
  def new
    @batch = Batch.new
    respond_to do |format|
      format.js { }
    end 
  end

  # GET /batches/1/edit
  def edit
  end

  # POST /batches
  # POST /batches.json
  def create
    @batch = Batch.new(batch_params)
    @batch.account_id = @current_account.id

    respond_to do |format|
      if @batch.save
        @batches = @current_account.batches.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Created', message: 'Successfully created batch' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to create batch' }
        format.js {}
      end
    end
  end

  # PATCH/PUT /batches/1
  # PATCH/PUT /batches/1.json
  def update
    respond_to do |format|
      if @batch.update(batch_params)
        @batches = @current_account.batches.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Updated', message: 'Successfully updated batch' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to update batch' }
        format.js {}
      end
    end
  end

  # DELETE /batches/1
  # DELETE /batches/1.json
  def destroy
    @batch.destroy
    respond_to do |format|
      @notification = { status: 'success', title: 'Deleted', message: 'Successfully deleted batch' }
      format.js { }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.where(:account_id => @current_account.id, :id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batch_params
      params.require(:batch).permit(:name)
    end
end
