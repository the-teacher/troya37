# Данные по умолчанию для сайта
namespace :db do
  # rake db:init
  desc 'create basic data'  
  task :init => ['db:drop', 'db:create', 'db:migrate', 'db:users:create']
      
  # Раздел создания базовых пользователей системы
  namespace :users do
    # rake db:users:create
    desc 'create basic users'
    task :create => :environment do
    
      # Создать администратора
      u = User.new
      u.login = 'admin'
      u.email = 'killich@yandex.ru'
      u.crypted_password = 'GjvbljH'
      u.salt = 'salt'
      u.name = 'Владелец сайта'
      u.save
      
      u.storage_sections.new(:name=>'Файлы сайта').save
      
      p 'ok!'
      
    end# db:users:create
  end#:users
end#:db