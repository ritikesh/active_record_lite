ActiveRecord::Schema.define do
    self.verbose = false
    
    create_table :users, :force => true do |t|
        t.string :name
        t.string :email
        
        t.timestamps
    end
    
    create_table :companies, :force => true do |t|
        t.string :name
        t.string :location
        
        t.timestamps
    end
    
end