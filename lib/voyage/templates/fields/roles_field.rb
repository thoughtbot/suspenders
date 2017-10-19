require 'administrate/field/base'

class RolesField < Administrate::Field::Base
  def to_s
    data.to_a.join(', ')
  end
end
