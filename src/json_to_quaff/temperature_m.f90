module json_to_quaff_temperature_m
  use quaff, only: &
    fallible_temperature_t, &
    fallible_temperature_unit_t, &
    parse_temperature, &
    parse_temperature_unit
  use rojff, only: &
    fallible_json_value_t, &
    json_value_t, &
    json_string_t
  use erloff, only: &
    error_list_t, &
    module_t, &
    procedure_t, &
    fatal_t

implicit none

interface fallible_temperature_t
    module procedure fallible_temperature_from_fallible_json_value
end interface
interface fallible_temperature_unit_t
  module procedure fallible_temperature_unit_from_fallible_json_value
end interface

character(len=*), parameter :: MODULE_NAME = "json_to_quaff_temperature_m"

contains

function fallible_temperature_from_fallible_json_value( &
  fallible_json_value) result(fallible_temperature)
  type(fallible_json_value_t), intent(in) :: fallible_json_value
  type(fallible_temperature_t) :: fallible_temperature

  character(len=*), parameter :: PROCEDURE_NAME = "fallible_temperature_from_fallible_json_value"

  if (fallible_json_value%failed()) then
      fallible_temperature = fallible_temperature_t(fallible_json_value%errors)
  else
      select type (json_value => fallible_json_value%value_)
          type is (json_string_t)
              fallible_temperature = fallible_temperature_t( &
                  parse_temperature(json_value%string), &
                  module_t(MODULE_NAME), &
                  procedure_t(PROCEDURE_NAME))
          class default
              fallible_temperature = fallible_temperature_t(error_list_t(fatal_t( &
                  module_t(MODULE_NAME), &
                  procedure_t(PROCEDURE_NAME), &
                  json_value%to_expanded_string() // " is not json_string_t type")))
      end select
  end if
end function

function fallible_temperature_unit_from_fallible_json_value( &
  fallible_json_value) result(fallible_temperature_unit)
  type(fallible_json_value_t), intent(in) :: fallible_json_value
  type(fallible_temperature_unit_t) :: fallible_temperature_unit

  character(len=*), parameter :: PROCEDURE_NAME = "fallible_temperature_unit_from_fallible_json_value"

  if (fallible_json_value%failed()) then
    fallible_temperature_unit = fallible_temperature_unit_t(fallible_json_value%errors)
  else
    select type (json_value => fallible_json_value%value_)
      type is (json_string_t)
        fallible_temperature_unit = fallible_temperature_unit_t( &
            parse_temperature_unit(json_value%string), &
              module_t(MODULE_NAME), &
              procedure_t(PROCEDURE_NAME))
      class default
        fallible_temperature_unit = fallible_temperature_unit_t(error_list_t(fatal_t( &
              module_t(MODULE_NAME), &
              procedure_t(PROCEDURE_NAME), &
              json_value%to_expanded_string() // " is not json_string_t type")))
    end select
  end if
end function

end module