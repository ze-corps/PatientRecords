require 'csv'
require 'util/import'

namespace :import do
  report =  File.open(Rails.root.join('db', 'csv','output', "Report.txt"), 'w')
  task all: :environment do
      Util::Import.import_class(report)
  end
end
