module Util
    module Export
      def self.export_class(class_name)
        cl = class_name.constantize
        puts "Starting #{class_name} download..."
        ActiveRecord::Base.transaction do
          csv_file = File.open(Rails.root.join('db', 'csv','output', "#{class_name}.csv"), 'w')
          data = cl.order(id: :asc).to_csv
          csv_file.write(data)
          csv_file.close
        end
        puts 'Download finished!'
      end
  
    end
end