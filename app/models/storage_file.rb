class StorageFile < ActiveRecord::Base  
  belongs_to :user
  belongs_to :storage_section

  has_attached_file :file,
                    :url => Project::FILE_URL,
                    :default_url=>Project::FILE_DEFAULT,
                    :processors => [:empty_processor]
=begin
  has_attached_file :file,
                    :styles => {
                      :small=> '100x100#',
                      :mini=>  '50x50#'
                    },
                    :convert_options => { :all => "-strip" },
                    :url => Project::FILE_URL,
                    :default_url=>Project::FILE_DEFAULT,
                    :processors => lambda { |a| a.is_image? ? [ :thumbnail ] : [:empty_processor ] }
=end
                    
  validates_presence_of :name, :message=>"Необходимо указать имя файла"

  validates_attachment_size :file,
                            :in => 1.kilobytes..1.megabytes,
                            :message=>'Размер должен быть больше 1 Килобайта и меньше 1 Мегабайта'

  def is_image?
    ['.gif','.jpeg','.jpg','.pjpeg','.png','.bmp'].include?(File.extname(file_file_name))
  end
  
  def is_doc?
    ['.doc', '.docx'].include?(File.extname(file_file_name))
  end
  
  def is_txt?
    ['text/plain'].include?(file.content_type)
  end
  
  def is_ppt?
    ['application/vnd.ms-powerpoint', 'application/x-ppt'].include?(file.content_type)
  end
  
  def is_xls?
    ['application/vnd.ms-excel'].include?(file.content_type)
  end
  
  def is_pdf?
    ['application/pdf'].include?(file.content_type)
  end  
  
  def is_psd?
    ['.psd'].include?(File.extname(file_file_name))
  end
  
  def is_media?
    ['video/x-msvideo','audio/wav','application/x-wmf','video/mpeg','audio/mpeg','audio/mp3'].include?(file.content_type)
  end
  
  def is_arch?
    ['.zip','.rar','.gz','.tar'].include?(File.extname(file_file_name))
  end
    
  # ------------------------------------------------------------------  
  before_validation_on_create :create_zip
  def create_zip
    # Если zip уже установлен ранее
    return unless (zip.nil? || zip.empty?)
    zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    while self.class.to_s.camelize.constantize.find_by_zip(zip_code)
      zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    end
    self.zip= zip_code
  end
end