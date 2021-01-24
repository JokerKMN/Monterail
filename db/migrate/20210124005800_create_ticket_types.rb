class CreateTicketTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_types do |t|
      t.string :name, null: false
      t.string :currency, null: false, default: 'EUR'
      t.integer :quantity_total, null: false
      t.integer :quantity_left, null: false
      t.integer :selling_option, null: false
      t.decimal :price, null: false
      t.belongs_to :event, null: false, foreign_key: { on_delete: :cascade }, index: { unique: false }

      t.timestamps
    end
  end
end
