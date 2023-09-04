class AddCompanyReferenceToDeviseUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :devise_users, :company, null: false, foreign_key: true
  end
end
