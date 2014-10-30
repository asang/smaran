class AccountPdf < Prawn::Document
  def initialize(account)
    super(top_margin: 75, page_size: 'A4', page_layout: :landscape)
    min_version(1.5)
    @font_size = 10
    @account = account
    account_name
    account_table
    encrypt_document( user_password: APP_CONFIG['pdf_key'],
                      owner_password: APP_CONFIG['pdf_key'] )
  end

  def account_name
    text "#{@account.name}", size: 20, style: :bold
  end

  def account_table
    move_down 20
    table account_rows do
      self.row_colors = ["DDDDDD", "FFFFFF"]
    end
  end
 
  def account_rows
    rows = [
      ["Name", "#{@account.name}"],
      ["Url", "#{@account.url}"],
      ["User Name", "#{@account.username}"],
      ["Password", "#{@account.password}"],
      ["Labels", @account.labels.to_a.map { |x| x.name }.join(", ")]
    ]
    rows << ["Comments", "#{@account.comments}"] unless @account.comments.empty?
    log_entries = ''
    @account.logs.reverse.each_with_index do |l, i|
      log_entries += "#{i+1}. #{l.content} " +
          "#{l.updated_at.strftime('%d, %b %y %l:%M %p (%Z)')}\n"
    end
    rows << ["Log Entries", log_entries ]
    rows
  end
end
# vi:set et ft=ruby ts=2 sw=2 ai:
