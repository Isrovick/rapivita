class Tran < ApplicationRecord
  belongs_to :usrto,   :class_name => 'User'
  belongs_to :usrfr,  :class_name => 'User'
  belongs_to :conv,    :class_name => 'Conv'
end
