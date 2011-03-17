# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  before_filter :navigation_menu_init, :only=>[:new]
  protect_from_forgery :except =>:create

  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      # Если установлен - производится восстановление сессии с сервера
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = {
          :value => self.current_user.remember_token,
          :expires => self.current_user.remember_token_expires_at,
          # look at! lib/authenticated_system.rb
          # look at! config/environment.rb
          :domain=>Project::COOKIES_SCOPE
        }
      end
      flash[:notice] = t('user.auth.entered')
      redirect_to(cabinet_users_url(:subdomain=>false))
      
    else
      flash[:warning] = t('user.auth.enter_error')
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete(
      :auth_token,
      :domain=>Project::COOKIES_SCOPE
    )
    reset_session
    flash[:notice] = t('user.auth.logouted')
    redirect_back_or_default('/')
  end
end
