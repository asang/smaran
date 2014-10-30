class AccountsPdf < Prawn::Document
  # @param [Account] accounts List of accounts
  # @param [String] title Title to use in generated pdf document
  # @return [Object]
  def initialize(accounts, title=nil)
    super(top_margin: 75, page_size: 'A4', page_layout: :landscape)
    min_version(1.5)
    @font_size = 10
    @accounts = accounts
    @title = title.nil? ? "List of accounts" : title
    heading
    accounts_table
    encrypt_document( user_password: APP_CONFIG['pdf_key'],
                      owner_password: APP_CONFIG['pdf_key'] )
  end

  def heading
    text @title, size: 20, style: :bold
  end

  def accounts_table
    move_down 20
    table all_rows do
      row(0).font_style = :bold
      self.row_colors = ["FFFFFF", "FFFFFF"]
    end
  end

  def all_rows
    rows = []
    rows << [ "Sr No", "Name", "Url", "User Name", "Password",
              "Labels", "Comments" ]
    @accounts.each_with_index do |a, i|
      rows << account_row(i + 1, a)
      log_entries = ''
      unless a.logs.count == 0
        a.logs.reverse.each_with_index do |l, i|
          log_entries += "#{i+1}. #{l.content} " +
              "#{l.updated_at.strftime('%d, %b %y %l:%M %p (%Z)')}\n"
        end
        # Add a new row for better alignment
        rows << [ "", "", "", "", "",
                  "Log Entries", log_entries ]
      end
    end
    rows
  end

  def account_row(i, a)
    [
      "#{i}.", "#{a.name}", "#{a.url}", "#{a.username}", "#{a.password}",
      a.labels.to_a.map { |x| x.name }.join(", "),
      a.comments.empty? ? "" : "#{a.comments}"
    ]
  end
end
# vi:set et ft=ruby ts=2 sw=2 ai: