# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  # Система авторизации
  include AuthenticatedSystem
  
  # Простая капча
  include SimpleCaptcha::ControllerHelpers
  
  #rescue_from ActionController::RoutingError, :with => :page_not_found
  #rescue_from ActionController::UnknownAction, :with=> :page_not_found
  #rescue_from WillPaginate::InvalidPage, :with=> :page_not_found
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  layout 'application'
  
  # Инициализация системных переменных
  before_filter :system_init
  before_filter :find_pages_for_navigation_menu
  
  protected

  def find_pages_for_navigation_menu
    @pages_tree= Page.find(:all, :order=>"lft ASC")
  end
    
  def page_not_found
    flash[:notice]= 'Раздел к которому Вы пытались обратиться временно не доступен'
    redirect_to root_url
  end

  def system_init 
    # Инициализировать флеш массив с системными уведомлениями
    flash[:system_warnings]= []
  end

  # Функция, необходимая для формирования базового меню-навигации
  # Отображаются только корневые разделы карты сайта
  def navigation_menu_init
    # Должен существовать хотя бы один пользователь
    @root_pages= Page.find(:all, :order=>"lft ASC")
  end
    
  # Перенаправление взамен стандартному
  # Используется в приложении
  def redirect_back_or(path)
    redirect_to :back
    rescue ActionController::RedirectBackError
    redirect_to path
  end
  
  def zip_for_model(class_name)
    zip= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    while class_name.to_s.camelize.constantize.find_by_zip(zip)
      zip= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    end
    zip
  end
  
end
