class Comment < ActiveRecord::Base
  attr_accessible :content
  belongs_to :commentable, polymorphic: true
  validates :content, presence: true
end
# vi:set et ts=2 sw=2 ai ft=ruby: