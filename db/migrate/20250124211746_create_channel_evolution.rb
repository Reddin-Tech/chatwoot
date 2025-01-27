class CreateChannelEvolution < ActiveRecord::Migration[6.1]
  def change
    create_table :channel_evolutions do |t|
      t.integer :account_id, null: false
      t.string :instance_name, null: false
      t.string :provider, default: 'evolution'
      t.string :phone_number
      t.jsonb :provider_config, default: {}
      t.string :webhook_url
      t.timestamps
    end

    add_index :channel_evolutions, :account_id
    add_index :channel_evolutions, :instance_name, unique: true
  end
end 