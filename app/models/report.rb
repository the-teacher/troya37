class Report < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :annotation
  validates_presence_of :content
  
  #publicated, hided
  state_machine :state, :initial => :hided do
    # ���������� �������
    event :publication do
      transition :hided => :publicated
    end
    # ������ � ����������
    event :hiding do
      transition :publicated => :hided
    end
  end
end
