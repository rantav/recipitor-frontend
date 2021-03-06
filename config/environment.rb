# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
RecipitorFrontend::Application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| 
  if html_tag =~ /<label/ 
    %|<div class="fieldWithErrors">#{html_tag} <span class="error">#{[instance.error_message].join(', ')}</span></div>|.html_safe
  else
    html_tag
  end
end

Rails.logger.info "Starting background processes"
t = Thread.new {
  ReceiptsController.poll_for_updates
}

