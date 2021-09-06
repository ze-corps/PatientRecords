module Util
    module Import
      def self.import_class
        classes = Dir.glob("#{Rails.root}/db/csv/*.csv").map{ |s| File.basename(s, File.extname(s)) }
        cl = 'PatientRecord'.constantize
        puts "Import Started"
        classes.each do |c|
          csv_text = File.read(Rails.root.join('db', 'csv', "patient_records.csv"))
          csv = CSV.parse(csv_text.scrub, headers: true)
          csv.each do |row|
            rec = cl.find_or_initialize_by(id: row['id'])
            rec.id = nil unless rec.persisted?
            rec.last_name = row['last_name'].strip
            rec.first_name = row['first_name'].strip
            rec.dob = reformat_date(row['dob'])
            # rec.dob = row['dob']
            rec.member_id = row['member_id'].strip
            rec.effective_date = row['effective_date']
            rec.expiry_date = row['expiry_date']
            rec.phone_number = convert_phone_number(row['phone_number'])
            saved = rec.save
          end
        end
        puts "Import END"
      end

      def  self.reformat_date(date)
        puts date
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
           puts new_year
           puts 'this'
           puts date_split
           puts Date.new(date_split[:year],date_split[:mon],date_split[:mday]).to_s
        end
      
        return "#{date[6..9]}-#{date[3..4]}-#{date[0..1]}"
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