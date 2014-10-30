class SearchSuggestion < ActiveRecord::Base
  attr_accessible :popularity, :term

  def self.terms_for(prefix)
    suggestions = where("term like ?", "%#{prefix}%")
    suggestions.order("popularity desc").limit(10).pluck(:term)
  end

  def self.index_accounts
    Account.find_each do |account|
      index_term(account.name)
      account.labels.find_each do |label|
        index_term(label.name)
      end
      account.name.split.each { |t| index_term(t) }
    end
  end

  def self.index_term(term)
    where(term: term.downcase).first_or_initialize.tap do |suggestion|
      suggestion.increment! :popularity
    end
  end
end
