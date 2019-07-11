module ActiveRecordLite
    class Base
        def self.columns
            columns = base_class.instance_variable_get(:@_arlcolumns) || base_class.column_names
            # must return this.
            columns.each_with_index { |column, index|
                @attr_lookup[column] = index
            }
        end

        def self.perform(sql)
            res = fetch_from_db(sql).map { |obj|
                new(obj)
            }
            res.size > 1 ? res : res.first
        end
        
        def initialize(obj)
            @attributes = obj
        end
        
        private
        
        attr_accessor :attributes
        
        def self.fetch_from_db(sql)
            base_class.connection.execute(sql)
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