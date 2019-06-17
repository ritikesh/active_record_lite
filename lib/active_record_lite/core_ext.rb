module ActiveRecordLite
    module CoreExt
        def has_lite(options={})
            if options.key?(:columns)
                @_arlcolumns = options.delete(:columns)
            end

            class_eval <<-EOV
                def self.to_lite
                    scoper = select(@_arlcolumns)
                    ActiveRecordLite#{name.gsub("::", "")}.new(scoper.to_sql)
                end
                
                class ActiveRecordLite#{name.gsub("::", "")} < ActiveRecordLite::Base
                    @base_class = parent
                    @attr_lookup = {}
                    columns.each do |column_name|
                        define_method(column_name) do
                            read_attribute(column_name)
                        end
                    end
                end
            EOV
        end
    end
end