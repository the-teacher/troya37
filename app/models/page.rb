class Page < ActiveRecord::Base  
  # Действуй как дерево, привязанное к владельцу (пользователю)
  acts_as_nested_set :scope=>:user
  belongs_to :user
  
  validates_presence_of   :user_id,     :message=>"Не определен идентификатор владельца страницы"
  validates_presence_of   :name,        :message=>"У страницы должено латинское имя"
  validates_uniqueness_of :name,        :message=>"У страницы должено быть уникальное латинское имя"
  validates_presence_of :title,         :message=>"У страницы должен быть заголовок"
  
  #validates_presence_of :author         #, :message=>"Системное поле: Автор &mdash; не должно оставаться пустым"
  #validates_presence_of :keywords       #, :message=>"Системное поле: Ключевые слова &mdash; не должно оставаться пустым"
  #validates_presence_of :description    #, :message=>"Системное поле: Описание &mdash; не должно оставаться пустым"
  #validates_presence_of :copyright      #, :message=>"Системное поле: Авторское право &mdash; не должно оставаться пустым"
  
  def to_param
    "#{name}"
  end
end
