class CreateErpTargetsCompanyTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_targets_company_targets do |t|
      t.string :name
      t.decimal :amount
      t.decimal :bonus_percent
      t.string :status
      t.references :period, index: true, references: :erp_periods_periods
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
