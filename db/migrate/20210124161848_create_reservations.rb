class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.integer :status, null: false
      t.belongs_to :event, null: false, foreign_key: { on_delete: :cascade }, index: { unique: false }

      t.timestamps
    end
  end
end
