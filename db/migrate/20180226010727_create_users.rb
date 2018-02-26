class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :auth_token
      t.datetime :token_expires_at

      t.timestamps
    end
  end
end
