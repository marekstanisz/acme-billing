class ChangePlanIdToReferences < ActiveRecord::Migration[7.0]
  def change
    remove_column :subscriptions, :plan_id, :string
    add_reference :subscriptions, :plan, null: false, foreign_key: true
  end
end
