class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :first_name
      t.string :last_name
      t.text :address
      t.string :zip_code
      t.string :plan_id
      t.string :payment_token
      t.date :next_billing_date

      t.timestamps
    end
  end
end
