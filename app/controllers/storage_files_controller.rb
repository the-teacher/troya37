class StorageFilesController < ApplicationController

  before_filter :login_required
  before_filter :find_file,  :only => [:destroy]

  # Показать все файлы данной секции
  def index
    @storage_section= StorageSection.find_by_zip(params[:id])
    @storage_section_files= StorageFile.paginate_all_by_storage_section_id(@storage_section.id,
                           :order=>"created_at DESC", #ASC, DESC
                           :page => params[:page],
                           :per_page=>2
                           )
  end
    
  def create
    @storage_section = StorageSection.find_by_zip(params[:storage_section_zip])
    
    if params[:storage_file] && params[:storage_file][:file]  
      @storage_file= StorageSection.find(:first).storage_files.new(params[:storage_file])
      @storage_file.user_id= current_user.id
    
      @storage_file.file= params[:storage_file][:file]
      @storage_file.zip= zip_for_model('StorageFile')
    
      extension = File.extname(@storage_file.file_file_name)
      @storage_file.file.instance_write(:file_name, "#{@storage_file.zip}#{extension}")
      
      respond_to do |format|
        if @storage_file.save
          flash[:notice] = 'Успешно загружено'
          format.html { redirect_to(storage_files_url(:id=>@storage_section.zip)) }
        else
          @storage_section_files= StorageFile.paginate_all_by_storage_section_id(@storage_section.id,
                                 :order=>"created_at DESC", #ASC, DESC
                                 :page => params[:page],
                                 :per_page=>20
                                 )
          format.html { render :action => "index" }
        end
      end#respond_to do |format|
    else
      flash[:warning] = 'Кажется, Вы забыли указать файл'
      redirect_to(storage_files_url(:id=>@storage_section.zip))
    end# if params[:storage_file]
  end
  
  def destroy
    @file.destroy
    flash[:red_alert] = 'Кажется, Вы удалили этот файл навсегда'
    redirect_back_or(storage_sections_url)
  end
  
  protected
  
  def find_file
    @file= StorageFile.find_by_zip(params[:id])
    access_denied and return unless @file
  end
  
  def find_storage_section
    @storage_section= StorageSection.find_by_zip(params[:id])
    access_denied and return unless @storage_section
  end
  
end
