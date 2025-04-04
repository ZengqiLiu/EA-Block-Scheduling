require_relative "../services/file_parser"

class ExcelFilesController < ApplicationController
  include Rails.application.routes.url_helpers
  include ExcelFilesHelper
  before_action :set_excel_file, only: %i[ show edit update destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  # GET /excel_files or /excel_files.json
  def index
    @excel_files = ExcelFile.all
  end

  # GET /excel_files/1 or /excel_files/1.json
  def show
    @attachment_url = helpers.attachment_url(@excel_file.file)
  end

  # GET /excel_files/new
  def new
    @excel_file = ExcelFile.new
  end

  # GET /excel_files/1/edit
  def edit
  end

  # POST /excel_files or /excel_files.json
  def create
    @excel_file = ExcelFile.new(excel_file_params)
    respond_to do |format|
      if @excel_file.save
        format.html { redirect_to @excel_file, notice: "Excel file was successfully uploaded and saved." }
        format.json { render :show, status: :created, location: @excel_file }
      else
        flash[:notice] = "Courses not added to database."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @excel_file.errors, status: :unprocessable_entity }
      end
      add_courses_to_database(@excel_file, @excel_file.id)
    end
  end

  # :nocov:

  # PATCH/PUT /excel_files/1 or /excel_files/1.json
  def update
    respond_to do |format|
      if @excel_file.update(excel_file_params)
        format.html { redirect_to @excel_file, notice: "Excel file was successfully updated." }
        format.json { render :show, status: :ok, location: @excel_file }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @excel_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /excel_files/1 or /excel_files/1.json
  def destroy
    @excel_file.destroy!

    respond_to do |format|
      format.html { redirect_to excel_files_path, status: :see_other, notice: "Excel file was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_excel_file
    @excel_file = ExcelFile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def excel_file_params
    params.require(:excel_file).permit(:name, :file)
  end

  # Handle RecordNotFound exception
  def handle_record_not_found
    respond_to do |format|
      format.html { redirect_to excel_files_path, alert: "Excel file not found." }
      format.json { render json: { error: "Excel file not found." }, status: :not_found }
    end
  end
  # :nocov:
end
