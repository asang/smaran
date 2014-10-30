namespace :search_suggestions do
  desc "Generates search suggestions from accounts"
  task :index => :environment do
    SearchSuggestion.index_accounts
  end
end