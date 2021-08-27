class CreateConvs < ActiveRecord::Migration[5.2]
  def change
    create_table :convs do |t|
      t.references :curto
      t.references :curfr
      t.float :rel

      t.timestamps
    end
  end
end
