module ActiveRecordLite
    class Railtie < Rails::Railtie
    
        initializer "active_record_lite.config_hook" do
            ActiveRecord::Base.extend(ActiveRecordLite::CoreExt)
        end
    end
end