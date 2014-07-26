class CreateTweeters < ActiveRecord::Migration
  def change
    create_table :tweeters do |t|
      t.string :twitter_id
      t.string :handle
      t.boolean :seed

      t.timestamps
    end
  end
end
