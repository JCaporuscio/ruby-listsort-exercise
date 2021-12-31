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
        end
    end

    def Outdoorsy.sort_users(sort_category = Category::FULL_NAME)
        @@user_database.sort_by! { |user| user[sort_category] }
    end
end