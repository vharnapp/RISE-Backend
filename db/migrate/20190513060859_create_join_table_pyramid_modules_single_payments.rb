class CreateJoinTablePyramidModulesSinglePayments < ActiveRecord::Migration[5.1]
  def change
    create_join_table :pyramid_modules, :single_payments do |t|
      # t.index [:pyramid_module_id, :single_payment_id]
      # t.index [:single_payment_id, :pyramid_module_id]
    end
  end
end
