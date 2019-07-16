module ActiveRecordLite
    module CoreExt
        def has_lite(options={})
            if options.key?(:columns)
                @_arlcolumns = options.delete(:columns)
            end
            class_eval <<-EOV
                def self.to_lite
                    scoper = unscope(:select).select(@_arlcolumns)
                    ActiveRecordLite.perform(scoper.to_sql)
                end
                
                class ActiveRecordLite < ActiveRecordLite::Base
                    @base_class = parent
                    @attr_lookup = {}
                    columns.each do |column_name|
                        type = parent.type_for_attribute(column_name).type 
                        if type.eql?(:datetime)
                            define_method(column_name) do
                                memoize_results(:"@\#{column_name}") {
                                    read_attribute(column_name).in_time_zone
                                }
                            end
                        elsif type.eql?(:boolean)
                            define_method(column_name) do
                                read_attribute(column_name) == 1
                            end
                            alias_method "\#{column_name}?", column_name
                        elsif type.eql?(:text) && parent.serialized_attributes.key?(column_name)
                            klass = parent.serialized_attributes[column_name]
                            define_method(column_name) do
                                memoize_results(:"@\#{column_name}") {
                                    klass.load(read_attribute(column_name))
                                }
                            end
                        else
                            define_method(column_name) do
                                read_attribute(column_name)
                            end
                        end
                    end
                end
            EOV
        end
    end
end