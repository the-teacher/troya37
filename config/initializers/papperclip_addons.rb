module Paperclip
  module Interpolations
    # ����������, ����������� � ���� ���������� �����������
    # ��������� ����� ����
    
    # :url => '/uploads/:attachment/:login/:style.jpg'
    def login attachment, style
      attachment.instance.login
    end
    
    def holder_login attachment, style
      attachment.instance.user.login
    end

    # :url => '/uploads/:attachment/:zip/:style.jpg'
    def zip attachment, style
      attachment.instance.zip
    end
  end
end