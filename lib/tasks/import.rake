require 'csv'
require 'util/import'

namespace :import do
 
  task all: :environment do
      Util::Import.import_class
  end
end
