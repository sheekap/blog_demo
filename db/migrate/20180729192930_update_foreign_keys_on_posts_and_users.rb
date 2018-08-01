class UpdateForeignKeysOnPostsAndUsers < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :posts, :user_id, on_delete: :cascade

    add_foreign_key :comments, :post_id, on_delete: :cascade

    add_foreign_key :comments, :user_id, on_delete: :cascade
  end
end
