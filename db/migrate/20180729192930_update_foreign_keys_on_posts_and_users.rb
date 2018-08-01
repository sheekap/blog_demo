class UpdateForeignKeysOnPostsAndUsers < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :posts, :index_posts_on_user_id
    add_foreign_key :posts, :user_id, on_delete: :cascade

    remove_foreign_key :comments, :index_comments_on_post_id
    add_foreign_key :comments, :post_id, on_delete: :cascade

    remove_foreign_key :comments, :index_comments_on_user_id
    add_foreign_key :comments, :user_id, on_delete: :cascade
  end
end
