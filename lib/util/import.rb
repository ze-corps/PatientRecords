module Util
    module Import
      def self.import_class(report)
        
        classes = Dir.glob("#{Rails.root}/db/csv/*.csv").map{ |s| File.basename(s, File.extname(s)) }
        cl = 'PatientRecord'.constantize
        a = 0
        report.write("#{Time.now} Import for file started...\n")
        classes.each do |c|
          ActiveRecord::Base.transaction do
            csv_text = File.read(Rails.root.join('db', 'csv', "patient_records.csv"))
            csv = CSV.parse(csv_text.scrub, headers: true)
            csv.each do |row|
              a = a + 1
              rec = cl.find_or_initialize_by(id: row['id'])
              rec.id = nil unless rec.persisted?
              rec.last_name = row['last_name'].strip
              rec.first_name = row['first_name'].strip
              rec.dob = reformat_date(row['dob'])
              # rec.dob = row['dob']
              rec.member_id = row['member_id'].strip 
              rec.effective_date = Date::strptime(row['effective_date'].gsub('-','/'),"%m/%d/%y").strftime('%F') unless row['effective_date'] == nil
              rec.expiry_date = Date::strptime(row['expiry_date'].gsub('-','/'),"%m/%d/%y").strftime('%F') unless row['expiry_date'] == nil
              rec.phone_number = convert_phone_number(row['phone_number'])
              saved = rec.save
            end
          rescue StandardError => e
             report.write("#{Time.now} Import Error...#{e} row number#{a}\n")        
          end
        end
        report.write("#{Time.now}Import Ended...\n")
      end

      def  self.reformat_date(date)
        puts date
        if (date == nil)
          return
        end
        cur_year =  Date.today.year.to_s
        date_split = Date._parse(date)
        new_year = ''
        puts date_split
        if(date_split[:mday]>31)
          puts new_year
            if ( date_split[:mday].to_i > cur_year[2..3].to_i )
                new_year = date_split[:mday].to_s.prepend('19')
            else 
                new_year = date_split[:mday].to_s.prepend('20')
            end 
           date_split[:year] = new_year.to_i
          #  byebug
           date_split[:mday] = date[0].to_i

          #  puts Date.new(date_split[:year],date_split[:mon],date_split[:mday]).to_s
        end
      
        return Date.new(date_split[:year],date_split[:mon],date_split[:mday]).to_s
      end
    
      def  self.convert_phone_number(_phone_number)
        # puts _phone_number
          new_arr = []
          arr = []
          if _phone_number != nil
            arr = _phone_number.split('')
            new_arr = arr.delete_if{|num| num.in?(['(',')','-',' ','.'])}
            if (new_arr.length == 10)
              final_phone = new_arr.join('').prepend('1')
            else 
              final_phone = new_arr.join('')
            end
            if (final_phone.length == 11)
              if(final_phone.split('')[0] == "1") 
                final_phone =  final_phone.prepend('+')
              end
            end 
            if (new_arr.length >= 11)
              final_phone = ''
              # puts 'error phone number'
            end
            return final_phone
          end
      end
    end
end
