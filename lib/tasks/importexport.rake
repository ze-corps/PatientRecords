require 'csv'
require 'util/import'
require 'util/export'

namespace :importexport do
    classes = ['PatientRecord']
  task all: :environment do
     report =  File.open(Rails.root.join('db', 'csv','output', "Report.txt"), 'w')
      Util::Import.import_class(report)
      classes.each do |c|
        Util::Export.export_class(c,report)
      end
  end
end