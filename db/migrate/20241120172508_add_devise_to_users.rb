class AddDeviseToUsers < ActiveRecord::Migration[7.2]
  def self.up
    change_table :users do |t|
      ## Database authenticatable
      # Skip adding 'email' as it already exists
      # Map 'password_digest' to 'encrypted_password' if necessary
      unless column_exists?(:users, :encrypted_password)
        t.rename :password_digest, :encrypted_password
        t.change :encrypted_password, :string, null: false, default: ""
      end

      ## Recoverable
      t.string   :reset_password_token unless column_exists?(:users, :reset_password_token)
      t.datetime :reset_password_sent_at unless column_exists?(:users, :reset_password_sent_at)

      ## Rememberable
      t.datetime :remember_created_at unless column_exists?(:users, :remember_created_at)

      ## Trackable (optional; commented out for now)
      # Uncomment these lines if you want tracking functionality
      # t.integer  :sign_in_count, default: 0, null: false unless column_exists?(:users, :sign_in_count)
      # t.datetime :current_sign_in_at unless column_exists?(:users, :current_sign_in_at)
      # t.datetime :last_sign_in_at unless column_exists?(:users, :last_sign_in_at)
      # t.string   :current_sign_in_ip unless column_exists?(:users, :current_sign_in_ip)
      # t.string   :last_sign_in_ip unless column_exists?(:users, :last_sign_in_ip)

      ## Confirmable (optional; uncomment if you use confirmable module)
      # t.string   :confirmation_token unless column_exists?(:users, :confirmation_token)
      # t.datetime :confirmed_at unless column_exists?(:users, :confirmed_at)
      # t.datetime :confirmation_sent_at unless column_exists?(:users, :confirmation_sent_at)
      # t.string   :unconfirmed_email unless column_exists?(:users, :unconfirmed_email)

      ## Lockable (optional; uncomment if you use lockable module)
      # t.integer  :failed_attempts, default: 0, null: false unless column_exists?(:users, :failed_attempts)
      # t.string   :unlock_token unless column_exists?(:users, :unlock_token)
      # t.datetime :locked_at unless column_exists?(:users, :locked_at)

      # Uncomment below if timestamps were not included in your original model
      # t.timestamps null: false
    end

    # Add indexes only if they don't already exist
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
    # Uncomment these indexes if you're using related modules
    # add_index :users, :confirmation_token, unique: true unless index_exists?(:users, :confirmation_token)
    # add_index :users, :unlock_token, unique: true unless index_exists?(:users, :unlock_token)
  end

  def self.down
    # Irreversible migration
    raise ActiveRecord::IrreversibleMigration
  end
end
