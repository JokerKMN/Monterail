class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :name, null: false
      t.belongs_to :ticket_type, null: false, foreign_key: { on_delete: :cascade }, index: { unique: false }

      t.timestamps
    end
  end
end
