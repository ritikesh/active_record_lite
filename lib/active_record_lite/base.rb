module ActiveRecordLite
    class Base
        def self.columns
            columns = base_class.instance_variable_get(:@_arlcolumns) || base_class.column_names
            # must return this.
            columns.each_with_index { |column, index|
                @attr_lookup[column] = index
            }
        end

        def self.perform(sql, selects)
            res = fetch_from_db(sql).map { |obj|
                new(obj, selects)
            }
            res.size > 1 ? res : res.first
        end
        
        def initialize(obj, selects)
            @attributes = obj
            @selects = selects&.map!(&:to_s)
        end
        
        private
        
        attr_reader :attributes, :selects
        
        def self.fetch_from_db(sql)
            base_class.connection.select_rows(sql)
        end
        
        def read_attribute(attr_name)
            if selects
                index = selects.index(attr_name)
                index && attributes[index]
            else
                index = self.class.attr_lookup(attr_name)
                attributes[index]
            end
        end

        def memoize_results(key)
            return instance_variable_get(key) if instance_variable_defined?(key)
            instance_variable_set(key, yield)
        end

        def self.attr_lookup(attr_name)
            @attr_lookup[attr_name]
        end

        def self.base_class
            @base_class
        end
    end
end