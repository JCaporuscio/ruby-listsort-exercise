require_relative "outdoorsy/category"
require_relative "outdoorsy/user"

module Outdoorsy
    # In this application there's only ever one database at a time
    #   so this is singleton functionality in a module.  Can convert to
    #   an object later if we need multiple db

    @@user_database = Array.new

    # We don't necessarily want to display every database value separately
    #   so define the subset we want
    @@display_categories = [
        Category::FULL_NAME,
        Category::EMAIL,
        Category::VEHICLE_TYPE,
        Category::VEHICLE_NAME,
        Category::VEHICLE_LENGTH
    ]

    def Outdoorsy.load_database(filepath, clear_existing = true)
        if clear_existing then @@user_database.clear() end

        begin
            IO.readlines(filepath, chomp: true).each do |db_line|
                @@user_database << User.new(db_line)
            end
        rescue StandardError
            puts "Error loading database file, data was not loaded."
            puts "Possible issues:"
            puts " - Make sure you entered an absolute path or path relative to calling directory."
            return
        end
        puts "Database Loaded"
    end

    def Outdoorsy.sort_users(sort_category = Category::FULL_NAME)
        @@user_database.sort_by! { |user| user[sort_category] }
    end

    def Outdoorsy.print_users
        if(@@user_database.size < 1) then print "\nNo Database Loaded\n"; return; end;

        left_pad = 1
        right_pad = 1
        column_width = User.min_string_width.each_with_object({}) do |(k, v), a|
            header_width = Category::NAME_STRING[k].length
            a[k] = v >= header_width ? v : header_width
        end
        column_delim = '|'

        puts ""

        # Table Header
        @@display_categories.each do |cat|
            print "#{Category::NAME_STRING[cat]
                        .center(left_pad + column_width[cat] + right_pad)}"
            print column_delim
        end
        puts""

        #break
        break_char = '-'
        @@display_categories.each do |cat|
            (left_pad + column_width[cat] + right_pad + column_delim.length)
                .times {print break_char}
        end
        puts ""

        #Table Contents
        #  Remember to print padding on the justified side
        @@user_database.each do |user|
            @@display_categories.each do |cat|
                case cat
                when Category::FULL_NAME
                    left_pad.times {print " "}
                    print "#{user[cat].ljust(column_width[cat] + right_pad)}"
                when Category::VEHICLE_LENGTH
                    print "#{user[cat].to_s
                                .rjust(left_pad + column_width[cat])}"
                    right_pad.times {print " "}
                else
                    print "#{user[cat].rjust(left_pad + column_width[cat])}"
                    right_pad.times {print " "}
                end
                print column_delim
            end
            puts ""
        end
        puts ""

    end
end