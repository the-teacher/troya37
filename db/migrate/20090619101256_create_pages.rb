class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :user_id  # Владелец страницы
      t.string  :name     # Английское имя страницы, фактически уникальный идентификатор :: Только латинские символы, !уникальное!

      # Мета информация
      # Поля текстовые специально для SEO-шников
      t.text :title     # Заголовок окна браузера страницы      
      t.text :author      # Автор страницы
      t.text :keywords    # Ключевые слова страницы
      t.text :description # Описание страницы
      t.text :copyright   # Авторское право
      t.text :head        # Добавочные данные для раздела Head, скрипты, CSS и прочая дрянь

      t.string :header    # Заголовок страницы      
      t.text   :content   # Содержимое страницы
      t.text   :footer    # Добавочные данные для раздела Footer (мало ли дураков, вдруг счетчики захотят поставить)
      
      # Поведение дерева (вложенные массивы - nested sets)
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
            
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
