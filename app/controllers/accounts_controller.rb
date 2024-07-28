class AccountsController < ApplicationController
  before_action :authenticate_student!
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  def dashboard
    @accounts= Account.all
    @exams = Exam.last(9)
    @papers = Paper.last(9)
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end
end
