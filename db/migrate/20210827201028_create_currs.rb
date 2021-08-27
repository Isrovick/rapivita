class CreateCurrs < ActiveRecord::Migration[5.2]
  def change
    create_table :currs do |t|
      t.string :cod
      t.string :desc
      t.string :typ

      t.timestamps
    end
  end
end
