class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    comment.commentable.updated_at = comment.created_at
    comment.commentable.save
  end

  def after_destroy(comment)
    comment.commentable.updated_at = Time.now
    comment.commentable.save
  end
end
# vi:set et ts=2 sw=2 ai ft=ruby: