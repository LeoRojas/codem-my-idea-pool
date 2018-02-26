class CreateIdeas < ActiveRecord::Migration[5.1]
  def change
    create_table :ideas do |t|
      t.string :content
      t.float :impact
      t.float :ease
      t.float :confidence
      t.float :average_score
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
