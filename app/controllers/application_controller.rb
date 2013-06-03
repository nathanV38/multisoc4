class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :layout_by_resource
  
  def layout_by_resource
    #if devise_controller? && action_name == 'sessions#new' #['authentications#new','sessions#new'].include?(action_name)
	if devise_controller? && resource_name == :user && action_name == 'new'
      "deviseoli"
	  #raise "ok works".to_yaml
    else
	  # "deviseoli"
      "application"
    end
  end
end
