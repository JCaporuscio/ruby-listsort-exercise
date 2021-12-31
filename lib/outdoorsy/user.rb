module Outdoorsy
    # Main class for Outdoor.sy user data.
    # Since each database entry is fundamentally a set of key-value pairs, 
    #   extend from Hash and then add any required functionality.
    class User < Hash

        # The database categories define each data item in the input database.
        # Order *must* match the order in the database file.
        @@db_categories = [
            :fname,
            :lname,
            :email,
            :vtype,
            :vname,
            :vlength
        ]

        # Store the max width of each catagory values across all created Users.
        # This will be useful when we need to display data.
        @@max_string_width = Hash.new(0)

        def initialize(db_line)
            super   # Could make the default an empty string, but nil is useful

            @delim = detect_delimiter(db_line)

            parse_db_line(db_line)
        end

        private def detect_delimiter(db_line)
            # This assumes a single delimiter in the database line
            [',', '|'].each do |delim|
                if(db_line.include?(delim)) then return delim end
            end
        end

        private def parse_db_line(db_line)
            values = db_line.split(@delim)
            
            # Rudimentary check that we're getting all the values we expect.
            # We may or may not want to still parse what values we can
            #   if the entry is shorter/longer
            if(@@db_categories.size == values.size)
                @@db_categories.each do |cat|
                    # pull the correct value from the respective location
                    #   in the database entry as determined by the order
                    #   of the @@db_categories values
                    value = values[@@db_categories.find_index(cat)]

                    # Vehicle Length is a special case since we get just the digits
                    unless cat == :vlength
                        self[cat] = value
                    else
                        self[cat] = extract_vehicle_length(value)
                    end
                end
            else
                #This should be real error handling instead of puts
                puts "Invalid Database entry encountered."
            end
        end

        # Unit notation on the length is inconsitent in the database, so
        #   extract the digits to get consistency calling code.
        # While the notation varies, all units are assumed as feet.
        private def extract_vehicle_length(length_string)
            return length_string.scan(/\d+/).join('').to_i
        end
    end
end