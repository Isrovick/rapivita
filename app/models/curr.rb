class Curr < ApplicationRecord

    has_many :curto_tra, :class_name => 'Tran'#, :foreing_key => 'tran_currto_id'
    has_many :curfr_tra, :class_name => 'Tran'#, :foreing_key => 'tran_currfr_id'
    has_many :curto_con, :class_name => 'Conv'#, :foreing_key => 'conv_currto_id'
    has_many :curfr_con, :class_name => 'Conv'#, :foreing_key => 'conv_currfr_id'
    has_many :curr_bal, :class_name => 'Balance'#, :foreing_key => 'bal_id'

end
