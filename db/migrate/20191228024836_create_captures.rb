class CreateCaptures < ActiveRecord::Migration[5.2]
  def change
    create_table :captures do |t|
      t.timestamps
      t.string  :image,     null: false
    end
  end
end
