class CreateVotes < ActiveRecord::Migration[4.2]
  def change
    create_table :votes do |t|
      t.integer :topic_id

      t.timestamps
    end
  end
end
