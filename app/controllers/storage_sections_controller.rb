class StorageSectionsController < ApplicationController
=begin
  def index
    @storage_sections= StorageSection.find_all_by_user_id(current_user.id)
    @storage_section= StorageSection.new
  end
  
  def show
    @storage_section= StorageSection.find_by_zip(params[:id])
    @storage_section_files= StorageFile.paginate_all_by_storage_section_id(@storage_section.id,
                           :order=>"created_at DESC", #ASC, DESC
                           :page => params[:page],
                           :per_page=>20
                           )
  end
  
  def create
    @storage_section= current_user.storage_sections.new(params[:storage_section])
    respond_to do |format|
      if @storage_section.save
        flash[:notice] = 'Раздел создан'
        format.html { redirect_to(storage_sections_path) }
      else
        flash[:notice] = 'Ошибка при создании раздела хранилища файлов'
        format.html { redirect_to(storage_sections_path) }
      end
    end
  end
  
  protected
  
  def find_storage_section
    @storage_section= StorageSection.find_by_zip(params[:id])
    access_denied and return unless @storage_section
  end
=end  
end
