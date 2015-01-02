require './environments'

class User < ActiveRecord::Base
  has_many :columns, dependent: :destroy
end

class Column < ActiveRecord::Base
  belongs_to :user
end
