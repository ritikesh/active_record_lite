class User < ActiveRecord::Base
    self.table_name =  'users'
    
    belongs_to :company

    serialize :preferences

    has_lite
end

class Company < ActiveRecord::Base
    self.table_name = 'companies'
    
    has_many :users

    has_lite columns: %w(id name active)
end