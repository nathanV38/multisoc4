class RegistrationsController < Devise::RegistrationsController  
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
	  session[:omniauth] = nil unless @user.new_record?   
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
end 