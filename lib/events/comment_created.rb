require 'delivery_boy'

module Events
  class CommentCreated
    TOPIC = "post.comment_created"
    def self.track!(comment, post)
      value = {
        post_id: post.id,
        user_id: comment.user.id,
        body: comment.body,
        post_comment_count: post.comments.count
      }

       DeliveryBoy.deliver_async(value.to_json, topic: TOPIC)
    end
  end
end
