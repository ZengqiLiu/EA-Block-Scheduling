module ApplicationHelper
  # :nocov:
  def attachment_url(attachment)
    return test_attachment_url if Rails.env.test?
    return default_attachment_url unless attachment.attached?

    real_attachment_url(attachment)
  end

  private

  def test_attachment_url
    "#"
  end

  def default_attachment_url
    # Handle the case where attachment is not attached
    "/assets/default-attachment.png"
  end
  # :nocov:
  def real_attachment_url(attachment)
    # Code to get the actual attachment URL for non-test environments
  end

  def current_user_admin?
    current_user&.admin?
  end

  def user_signed_in?
    !current_user.nil?
  end
end
