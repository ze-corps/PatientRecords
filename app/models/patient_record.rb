class PatientRecord < ApplicationRecord
  require 'csv'
  def self.to_csv
    attributes = ['id', 'first_name','last_name', 'dob', 'member_id', 'effective_date', 'expiry_date', 'phone_number']
    CSV.generate(headers: true) do | csv |
      csv << attributes
      all.each do | record |
        csv << record.attributes.values_at(*attributes)
      end
    end
  end
end
