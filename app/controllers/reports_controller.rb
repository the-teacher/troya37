class ReportsController < ApplicationController
  before_filter :login_required,  :except=> [:index, :show]
  
  def index
    @reports = Report.paginate_all_by_state('publicated',
      :order=>"created_at DESC", #ASC, DESC
      :page => params[:page],
      :per_page=>3
    )
    respond_to do |format|
      format.html
    end
  end
  
  def manager
    @reports = Report.paginate(:all, 'publicated',
      :order=>"created_at DESC", #ASC, DESC
      :page => params[:page],
      :per_page=>10
    )
    respond_to do |format|
      format.html
    end
  end

  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @report = Report.new

    respond_to do |format|
      format.html
    end
  end

  def change_state
    @report = Report.find(params[:id])
    
    if @report.can_hiding?
      flash[:notice] = 'Снято с публикации'
      @report.hiding
    else
      flash[:notice] = 'Опубликовано'
      @report.publication if @report.can_publication?
    end
    redirect_to(manager_reports_path)
  end
  
  def edit
    @report = Report.find(params[:id])
  end

  def create
    @report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        flash[:notice] = 'Новость успешно создана'
        format.html { redirect_to(manager_reports_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        flash[:notice] = 'Новость успешно обновлена'
        format.html { redirect_to(edit_report_path(@report)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    flash[:notice] = 'Новость удалена безвозвратно'
    respond_to do |format|
      format.html { redirect_to(manager_reports_path) }
    end
  end
end
