class User < ApplicationRecord

    has_many :to_tran, :class_name => 'Tran'#, :foreing_key => 'to_tran_id'
    has_many :fr_tran, :class_name => 'Tran'#, :foreing_key => 'fr_tran_id'
    has_many :bal, :class_name => 'Balance'#, :foreing_key =>  'bal_id'

    has_secure_password
    
    validates_presence_of :email
    validates_uniqueness_of :email

end
