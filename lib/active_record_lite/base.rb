module ActiveRecordLite
    class Base
        def self.columns
            columns = base_class.instance_variable_get(:@_arlcolumns) || base_class.column_names
            # must return this.
            columns.each_with_index { |column, index|
                @attr_lookup[column] = index
            }
        end
        
        def initialize(sql)
            fetch_from_db(sql)
        end
        
        private
        
        attr_accessor :attributes
        
        def fetch_from_db(sql)
            @attributes = execute_select(sql).first
        end
        
        def execute_select(sql)
            ActiveRecord::Base.connection.execute(sql)
        end
        
        def read_attribute(attr_name)
            attributes[self.class.attr_lookup(attr_name)]
        end

        def self.attr_lookup(attr_name)
            @attr_lookup[attr_name]
        end

        def self.base_class
            @base_class
        end
    end
end