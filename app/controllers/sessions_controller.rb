class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [ :new, :create ]

  def new
  end

  def create
    user = User.find_by(email:)

    if user
      if user.authenticate(password)
        log_in(user)
        redirect_to(root_path)
      else
        flash.now[:error] = "Invalid email/password"
        render "new", status: 401
      end
    else # User does not exist so create the user
      user = User.new(email:, password:)
      if user.save
        log_in(user)
        redirect_to(root_path)
      else
        render "new"
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def email
    params[:session][:email].downcase
  end

  def password
    params[:session][:password]
  end
end
