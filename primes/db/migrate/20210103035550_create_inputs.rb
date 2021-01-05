class CreateInputs < ActiveRecord::Migration[5.2]
  def change
    create_table :inputs do |t|
      t.integer :input
      t.integer :output, array: true
      t.boolean :validInput
      t.references :system, foreign_key: true

      t.timestamps
    end
  end
end
