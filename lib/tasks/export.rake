require 'csv'
require 'util/export'

namespace :export do
  report =  File.open(Rails.root.join('db', 'csv','output', "Report.txt"), 'w')
  classes = ['PatientRecord']
  task all: :environment do
    classes.each do |c|
      Util::Export.export_class(c,report)
    end
  end

end