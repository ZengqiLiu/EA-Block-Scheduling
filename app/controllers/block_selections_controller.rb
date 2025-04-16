class BlockSelectionsController < ApplicationController
  before_action :ensure_student

  def create
    Rails.logger.info "Params: #{params[:block].inspect}"
    selected_ids = params.dig(:block, :selected_block_ids)
    if selected_ids.blank?
      flash[:alert] = "No block was selected. Please select a block."
      redirect_back fallback_location: blocks_path and return
    elsif selected_ids.size > 1
      flash[:alert] = "Please only select one block."
      redirect_back fallback_location: blocks_path and return
    end
 
    selected_block_id = selected_ids.first.to_s
    courses_hash = params[:block][:courses] || {}
    courses_hash = courses_hash.transform_keys(&:to_s)
    courses_for_selected = courses_hash[selected_block_id]

    if courses_for_selected.blank?
      flash[:alert] = "No courses found for the selected block."
      redirect_back fallback_location: blocks_path and return
    end

    block_instance = Block.new(courses_for_selected)

    if block_instance.valid?
      current_user.create_block_selection!(course_ids: block_instance.courses.map(&:id))
      flash[:notice] = "Block successfully selected."
      redirect_back fallback_location: blocks_path
    else
      flash[:alert] = "Invalid block"
      redirect_back fallback_location: blocks_path
    end
  end

  private

  def ensure_student
    redirect_to root_path, alert: "Access denied." unless current_user.student?
  end

  def block_params
    params.require(:block).permit(courses: {}, selected_block_ids: [])
  end
end
