class Tran < ApplicationRecord
  belongs_to :usrto
  belongs_to :userfr
  belongs_to :conv
end
