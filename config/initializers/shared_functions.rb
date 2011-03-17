def include_global name= ''
  content= ''
  file_name= "#{Rails.root}/config/globals/#{name.to_s}.txt" 

  if File.exists?(file_name)
    File.open(file_name).each_line do |line|
      content<< line
    end
  end

  content
end#include_global
