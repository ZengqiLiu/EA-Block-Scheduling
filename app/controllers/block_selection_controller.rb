class BlockSelectionController < ApplicationController
  before_action :ensure_student

  def create
    block = Block.new(block_params[:courses])
    
    if block.valid?
      current_user.create_block_selection!(course_ids: block.courses.map(&:id))
      redirect_to dashboard_path, notice: "Block successfully saved."
    else
      flash[:alert] = "Invalid block"
      redirect_to new_block_selection_path
    end
  end

  private

  def ensure_student
    redirect_to root_path, alert: "Access denied." unless current_user.student?
  end

  def block_params
    params.require(:block).permit(courses: [])
  end
end
