class PatientRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :patient_records do |t|
      t.string :last_name
      t.string :first_name
      t.date :dob
      t.integer :member_id
      t.date :effective_date
      t.date :expiry_date
      t.string :phone_number

      t.timestamps
    end
  end
end

