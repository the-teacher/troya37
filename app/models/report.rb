class Report < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :annotation
  validates_presence_of :content
  
  #publicated, hided
  state_machine :state, :initial => :hided do
    # Публикация новости
    event :publication do
      transition :hided => :publicated
    end
    # Снятие с публикации
    event :hiding do
      transition :publicated => :hided
    end
  end
end
