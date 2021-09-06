require 'csv'
require 'util/export'

namespace :export do
  
  classes = ['PatientRecord']
  task all: :environment do
    classes.each do |c|
      Util::Export.export_class(c)
    end
  end

end