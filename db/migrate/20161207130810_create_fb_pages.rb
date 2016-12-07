class CreateFbPages < ActiveRecord::Migration
  def change
    create_table :fb_pages do |t|
      t.string :name
      t.string :page_id
      t.integer :post_amount

      t.timestamps null: false
    end
  end
end
