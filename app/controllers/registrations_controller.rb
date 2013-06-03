class RegistrationsController < Devise::RegistrationsController  
#layout "inscription"

  private  
  def build_resource(*args)  
    super  
    if session[:omniauth]  
      @user.apply_omniauth(session[:omniauth])  
      @user.valid?  
    end  
  end  
  
  public
  def create  
	  super  
	  #raise @user.to_yaml
	  
	  
	  session[:omniauth] = nil unless @user.new_record?   
	  
	  #raise @user.to_yaml
	  #raise params[resource_name][:haslocalpw].to_yaml
  end 
  
  def destroy
		#raise current_user_temp.to_yaml
		if current_user_temp
			#raise current_user_temp["user_id"].to_yaml
			@associated_athentication = Authentication.find_by_user_id(current_user_temp[:id])
			if @associated_athentication != nil
				#raise @associated_athentication.to_yaml
				@associated_athentication.destroy
			end
		end 
		
		super
  end
  
  def current_user_temp
		omni = request.env["omniauth.auth"]
		@current_user ||= User.find_by_email(omni['info']['email'])
  end
  
  
  
  def update
  # no mass assignment for country_id, we do it manually
  # check for existence of the country in case a malicious user manipulates the params (fails silently)
  
  #raise current_user.to_yaml
  
  if params[resource_name][:country_id]          
    resource.country_id = params[resource_name][:country_id] if Country.find_by_id(params[resource_name][:country_id])
  end

  if current_user.haslocalpw
    super
	
	
	
  else
	
    # this account has been created with a random pw / the user is signed in via an omniauth service
    # if the user does not want to set a password we remove the params to prevent a validation error
    if params[resource_name][:password].blank? 
      params[resource_name].delete(:password) 
      params[resource_name].delete(:password_confirmation) if params[resource_name][:password_confirmation].blank? 
    else
      # if the user wants to set a password we set haslocalpw for the future
      params[resource_name][:haslocalpw] = true
    end
    
    # this is copied over from the original devise controller, instead of update_with_password we use update_attributes
    if resource.update_attributes(params[resource_name])
       set_flash_message :notice, :updated
       sign_in resource_name, resource
       redirect_to after_update_path_for(resource)
     else
       clean_up_passwords(resource)
       render_with_scope :edit
     end
  end
end
end 