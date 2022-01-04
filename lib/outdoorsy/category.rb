module Outdoorsy
    module Category
        # This module contains all possible categories of data, both
        #   database-side and display
        FIRST_NAME = :fname
        LAST_NAME = :lname
        FULL_NAME = :name
        EMAIL = :email
        VEHICLE_TYPE = :vtype
        VEHICLE_NAME = :vname
        VEHICLE_LENGTH = :vlength

        NAME_STRING = {
            fname: "First Name",
            lname: "Last Name",
            name: "Name",
            email: "Email Address",
            vtype: "Vehicle Type",
            vname: "Vehicle Name",
            vlength: "Vehicle Length (Feet)"
        }
    end
end