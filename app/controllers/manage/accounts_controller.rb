class Manage::AccountsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def set_current
    session[:current_account_id] = params[:id]
    redirect_to dashboard_manage_accounts_path
  end

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = current_teacher.accounts.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
      format.any { render nothing: true, status: :not_acceptable }
    end
  end

  def dashboard
    @accounts = current_teacher.accounts
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # # GET /accounts/new
  # def new
  #   @account = Account.new
  # end
  #
  # # GET /accounts/1/edit
  # def edit
  # end
  #
  # # POST /accounts
  # # POST /accounts.json
  # def create
  #   @account = Account.new(account_params)
  #   @account.owner = current_teacher
  #
  #   respond_to do |format|
  #     if @account.save
  #       format.html { redirect_to @account, notice: 'Account was successfully created.' }
  #       format.json { render :show, status: :created, location: @account }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @account.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # PATCH/PUT /accounts/1
  # # PATCH/PUT /accounts/1.json
  # def update
  #   respond_to do |format|
  #     if @account.update(account_params)
  #       format.html { redirect_to @account, notice: 'Account was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @account }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @account.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # DELETE /accounts/1
  # # DELETE /accounts/1.json
  # def destroy
  #   @account.destroy
  #   respond_to do |format|
  #     format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = current_teacher.accounts.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :phone, :address, :email)
    end
end
