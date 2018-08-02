class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:show]
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @comments = Comment.all
  end

  def show
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    require 'google/protobuf'
    require 'google/protobuf/well_known_types'
    require './protobuf_schemas/protobuf_schemas/comment_created_pb'

    @post = Post.find(params[:post_id])
    @comment = current_user.comments.create(comment_params_with_post)
    topic = "post.comment_created"

    msg = ProtobufSchemas::CommentCreated.new(
      post_id: Google::Protobuf::Int64Value.new(value: @post.id),
      user_id: Google::Protobuf::Int64Value.new(value: @comment.user.id),
      body: Google::Protobuf::StringValue.new(value: @comment.body),
      post_comment_count: Google::Protobuf::Int64Value.new(value: @post.comments.count)
    )

    encoded_msg = ProtobufSchemas::CommentCreated.encode(msg)

    DeliveryBoy.deliver_async(encoded_msg, topic: topic, key: @post.id)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    post = Post.find(@comment.post_id)
    topic = "comment.updated"

    value = {
      post_id: post.id,
      post_title: post.title,
      user_id: user.id,
      body: comment.body,
      likes: comment.likes
    }

    DeliveryBoy.deliver_async(value.to_json, topic: topic)

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params_with_post
      comment_params.merge(post: @post)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.fetch(:comment, {}).permit(:body)
    end
end
