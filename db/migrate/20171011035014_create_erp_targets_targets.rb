class CreateErpTargetsTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_targets_targets do |t|
      t.references :salesperson, index: true, references: :erp_users
      t.references :period, index: true, references: :erp_periods_periods
      t.decimal :amount, default: 0.0
      t.string :status
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
