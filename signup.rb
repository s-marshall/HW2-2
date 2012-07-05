require 'sinatra'
require 'haml'

class SignupApp < Sinatra::Base
  def validate_username(username)
    username =~ /^[a-zA-Z0-9_-]{3,20}$/
  end

  def validate_password(password)
    password =~ /^.{3,20}$/
  end
  
  def validate_email(email)
    email =~ /^[\S]+@[\S]+\.[\S]+$/
  end
  
  def write_form(username_error='', password_error='', verify_error='', email_error='')
    @invalid_username = username_error
    @invalid_password = password_error
    @invalid_verify = verify_error
    @invalid_email = email_error
    
    haml :signup, :locals => {	:username => params[:username],
      							:password => params[:password],
    							:verify => params[:verify],
    							:email => params[:email]
    							}
  end
   
  get '/signup' do
    haml :signup
  end
  
  post '/signup' do
    @valid_input = true
    if validate_username(params[:username]) == nil
      @invalid_username = %Q{This is not a valid username.}
      @valid_input = false
    else
      @invalid_username = ''
    end
    
    if validate_password(params[:password]) == nil
      @invalid_password = %Q{This is not a valid password.}
      @valid_input = false
    else
      @invalid_password = ''
    end
    
    if params[:password] != params[:verify]
      @invalid_verify = %Q{The passwords do not match.}
      @valid_input = false
    else
      @invalid_verify = ''
    end
    
    if (params[:email] != '') && (validate_email(params[:email]) == nil)
      @invalid_email = %Q{This is not a valid email address.}
      @valid_input = false
    else
      @invalid_email = ''
    end
    
    if @valid_input == true
      redirect to(%Q{/welcome?username=#{params[:username]}})
    else
      write_form(@invalid_username, @invalid_password, @invalid_verify, @invalid_email)
    end
  end
  
  get '/welcome' do
    haml :welcome
  end

end
