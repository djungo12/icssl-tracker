class CreateIcssls < ActiveRecord::Migration
  def change
    create_table :icssls do |t|
      t.string :name
      t.string :city
      t.string :state
      t.integer :cert_no
      t.string :type

      t.timestamps null: false
    end
  end
end
