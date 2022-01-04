require_relative "outdoorsy"

help_string = File.read(File.expand_path("../helpText.txt", __FILE__))

def input_qty_correct?(inputs, expected_qty, error_msg)
    if(inputs.size == expected_qty)
        return true
    elsif(inputs.size > expected_qty)
        puts "Too many arguments. #{error_msg}"
    else
        puts "Too few arguments. #{error_msg}"
    end
    return false
end

quit = false

until quit

    print "Outdoor.sy> "
    inputs = gets.chomp.split(" ")

    command = inputs.shift

    case command
    when "commands", "c", "help", "h"
        puts help_string

    when "load", "l"
        clear_existing = true
        if inputs.include? "-a"
            clear_existing = false
            inputs.delete("-a")
        end

        if(input_qty_correct?(inputs, 1, "Expected path and up to 1 option"))
            Outdoorsy.load_database(inputs[0], clear_existing)
            puts""
            Outdoorsy.print_users
        end

    when "print", "p"
        Outdoorsy.print_users

    when "quit", "q"
        quit = true

    when "sort", "s"
        if(input_qty_correct?(inputs, 1, "Expected 1 Sort Category"))
            if Outdoorsy.display_categories.map{|s| s.to_s}.include? inputs[0]
                Outdoorsy.sort_users(inputs[0].to_sym)
                Outdoorsy.print_users
            else
                puts "Invalid Sort Category.  Type 'commands' for a list of valid categories"
            end
        end

    else
        puts "Invalid Command.  Type 'commands' for a list of commands'."
    end

end