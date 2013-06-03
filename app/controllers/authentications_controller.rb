class AuthenticationsController < ApplicationController
#layout "inscription"

  def index
    @authentications = Authentication.all
  end

  def create
    @authentication = Authentication.new(params[:authentication])
    if @authentication.save
      redirect_to authentications_url, :notice => "Successfully created authentication."
    else
		render :action => 'new'
		
    end
  end

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, :notice => "Successfully destroyed authentication."
  end
  
  def home
 
  end
  
  def current_user_temp
		omni = request.env["omniauth.auth"]
		@current_user ||= User.find_by_email(omni['info']['email'])
  end
  
  def failure
	#raise omni = request.env["omniauth.auth"].to_yaml
	redirect_to authentications_url, :notice => "Il y a eu un pb -> failure." + request.env["omniauth.auth"].to_yaml
  end
  
  def twitter
     #raise omni = request.env["omniauth.auth"].to_yaml
	 omni = request.env["omniauth.auth"]
	 authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])
	 session["provider"] = omni['provider']
	 
	 if authentication
		# si twitter est en attente dans l'email -> demande de confirmer pass ou de renvoyer autre email
		userassociated = User.find(authentication.user_id)
		if userassociated != nil
			if userassociated.confirmation_token != nil && userassociated.confirmed_at == nil
				flash[:notice] = "confirmer votre inscription par email pour pouvoir vous connecter"
				redirect_to new_user_confirmation_path
			else
				flash[:notice] = "Logged in Successfully"
				sign_in_and_redirect User.find(authentication.user_id)
			end
		end
	
	 elsif current_user
		 token = omni['credentials'].token
		 token_secret = omni['credentials'].secret
		 
		 current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
		 flash[:notice] = "Authentication successful."
		 sign_in_and_redirect current_user
		 
	 else
		 user = User.new
		 user.apply_omniauth(omni)
		 user.haslocalpw=false
		 
		 if user.save
			 flash[:notice] = "Logged in."
			 sign_in_and_redirect User.find(user.id)
		 else
			 session[:omniauth] = omni.except('extra')
			 redirect_to new_user_registration_path
		 end
	 end
  end	 
  
   def facebook
     #raise omni = request.env["omniauth.auth"].to_yaml
	 omni = request.env["omniauth.auth"]
	 #raise omni['info']['email'].to_yaml
	 authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])
	 session["provider"] = omni['provider']
	 
	 #raise "current_user_temp"+current_user_temp.to_yaml
	 
		 if authentication
			flash[:notice] = "Logged in Successfully"
			sign_in_and_redirect User.find(authentication.user_id)
		
		
		
	#	 elsif current_user
	#		 token = omni['credentials'].token
	#		 token_secret = omni['credentials'].secret
			 
	#		 current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
	#		 flash[:notice] = "Authentication successful."
	#		 sign_in_and_redirect current_user
		 
		 elsif current_user_temp
			 current_user_temp.skip_confirmation! #pour éviter le mail de conf
			 token = omni['credentials'].token
			 token_secret = omni['credentials'].secret
			 
			 current_user_temp.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
			 flash[:notice] = "Authentication successful."
			 sign_in_and_redirect current_user_temp 


		 
		 else
			 user = User.new
			 #pour éviter la confirmation par mail
			 user.skip_confirmation!
			 user.email = omni['info']['email']
			 user.haslocalpw=false
			 user.apply_omniauth(omni)
			 
			 #raise user.to_yaml
			 
			 if user.save
				 flash[:notice] = "Logged in."
				 sign_in_and_redirect User.find(user.id)
			 else
				 session[:omniauth] = omni.except('extra')
				 redirect_to new_user_registration_path
			 end
		 end
  end	

  
  def google_oauth2
     #raise omni = request.env["omniauth.auth"].to_yaml
	 omni = request.env["omniauth.auth"]
	 #raise omni['info']['email'].to_yaml
	 authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])
	 session["provider"] = omni['provider']
	 
	 #raise "current_user_temp"+current_user_temp.to_yaml
	 
		 if authentication
			flash[:notice] = "Logged in Successfully"
			sign_in_and_redirect User.find(authentication.user_id)
		
		
		
	 #	 elsif current_user
	 #		 token = omni['credentials'].token
	 #		 token_secret = omni['credentials'].secret
			 
	 #		 current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
	 #		 flash[:notice] = "Authentication successful."
	 #		 sign_in_and_redirect current_user
		 
		 elsif current_user_temp
			 current_user_temp.skip_confirmation! #pour éviter le mail de conf
			 token = omni['credentials'].token
			 token_secret = omni['credentials'].secret
			 
			 current_user_temp.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
			 flash[:notice] = "Authentication successful."
			 sign_in_and_redirect current_user_temp 


		 
		 else
			 user = User.new
			 #pour éviter la confirmation par mail
			 user.skip_confirmation!
			 
			 user.email = omni['info']['email']
			 user.haslocalpw=false
			 user.apply_omniauth(omni)
			 
			 #raise user.to_yaml
			 
			 if user.save
				 flash[:notice] = "Logged in."
				 sign_in_and_redirect User.find(user.id)
			 else
				 session[:omniauth] = omni.except('extra')
				 redirect_to new_user_registration_path
			 end
		 end
  end
  
end
