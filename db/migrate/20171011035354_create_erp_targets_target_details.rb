class CreateErpTargetsTargetDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_targets_target_details do |t|
      t.references :target, index: true, references: :erp_targets_targets
      t.decimal :percent, default: 0.0
      t.decimal :commission_amount, default: 0.0

      t.timestamps
    end
  end
end
