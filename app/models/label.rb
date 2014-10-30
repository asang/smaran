class Label < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_and_belongs_to_many :accounts
  attr_accessible :name, :description, :account_ids

  validates :name, :presence => true,
    :format => {:with => /\A\w+\s*\w*\z/}
  validates :description, :presence => true

  def sorted_accounts
    return accounts if accounts.nil?
    accounts.sort { |x,y| x.name <=> y.name }
  end

  def self.sorted_labels
    return Label.all.sort { |x,y| x.name <=> y.name }
  end

  def self.sorted_labels_by_desc
    return Label.all.sort { |x,y| x.description <=> y.description }
  end

  before_save { |a|
    a.name = a.name.downcase
    a.description = a.description.capitalize
  }

  before_destroy :ensure_does_not_have_accounts

  private

  # If label has one or more accounts, it cannot be deleted
  def ensure_does_not_have_accounts
    if accounts.count > 0
      s = pluralize(accounts.length, "account")
      errors.add(:base,
                 "#{name} still has #{s}")
      return false
    end
    return true
  end
end
# vi:set et ts=2 sw=2 ai ft=ruby:
