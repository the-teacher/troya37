class PagesController < ApplicationController  
  # Формирование данных для отображения базового меню-навигации
  # Проверка на регистрацию
  # Поиск ресурса для обработчиков, которым он требуется
  before_filter :navigation_menu_init,                  :except=> [:show, :edustat, :first]
  before_filter :login_required,                        :except=> [:index, :show, :first]
  before_filter :find_page,                             :only=>   [:show, :edit, :update, :destroy, :up, :down]

  # Карта сайта
  # Выбрать дерево страниц, только те поля, которые учавствуют отображении
  #def index
  #@pages_tree= Page.find_all_by_user_id(@user.id, :select=>'id, title, zip, parent_id', :order=>"lft ASC")
  #end
    
  def first
    @page= @pages_tree.first
  end

  def show
    @page= Page.find_by_name(params[:id])
    @parents= @page.self_and_ancestors if @page
    @siblings= @page.children if @page
  end
  
  # Карта сайта редактора
  def manager
    @pages_tree_for_tree_rendering = Page.find(:all, :select=>'id, title, header, name, parent_id', :order=>"lft ASC")
  end
  
  def new
    @parent= nil
    @parent= Page.find_by_name(params[:parent_id]) if params[:parent_id]
    @page= Page.new
  end
  
  def create
    @page= current_user.pages.new(params[:page])
    #@parent= nil
    #@parent= Page.find_by_name(params[:parent_id]) if params[:parent_id]
    respond_to do |format|
      if @page.save
        @page.move_to_child_of(@parent) if @parent
        flash[:notice] = t('page.created')
        format.html { redirect_to(edit_page_path(@page.name)) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def edit
    # before_filter
  end
  
  # PUT /pages/2343-5674-3345
  def update
    respond_to do |format|
      name= @page.name
      if @page.update_attributes(params[:page])
        flash[:notice] = t('page.updated')
        format.html { redirect_to(edit_page_path(@page)) }
      else
        @page.name= name
        format.html { render :action => "edit" }
      end
    end
  end

  def up
    if @page.move_possible?(@page.left_sibling)
      @page.move_left
      flash[:notice] = t('page.up')
    else
      flash[:notice] = t('page.cant_move')
    end
    redirect_to(manager_pages_path) and return
  end
  
  def down
    if @page.move_possible?(@page.right_sibling)
      @page.move_right
      flash[:notice] = t('page.down')
      redirect_to(manager_pages_path) and return
    else
      flash[:notice] = t('page.cant_be_move')
      redirect_to(manager_pages_path) and return
    end
  end

  def destroy
    if @page.children.count.zero?
      @page.destroy
      flash[:notice]= t('page.deleted')
    else
      flash[:notice]= t('page.has_children')
    end
    redirect_to(manager_pages_path) and return
  end
 
  protected
  
  def find_page
    @page= Page.find_by_name(params[:id])
    access_denied and return unless @page
  end
end