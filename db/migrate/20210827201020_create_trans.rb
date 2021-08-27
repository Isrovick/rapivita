class CreateTrans < ActiveRecord::Migration[5.2]
  def change
    create_table :trans do |t|
      t.references :usrto
      t.references :userfr
      t.references :conv
      t.float :bal
      t.timestamps
    end
  end
end
