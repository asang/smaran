# vi:set et ts=2 sw=2 ai ft=ruby:
#
# Account in an online web based or any other
# system. For each account, we track +username+,
# +password+, +url+ and some +comments+.
#
# ==== Examples
#   Account.create(:username => 'asang', :password => 'abc')
#
require 'csv'

class Account < ActiveRecord::Base
  attr_encrypted :url, :password, :comments,
    :key => Proc.new { |x| APP_CONFIG['master_key'] }
  has_and_belongs_to_many :labels
  has_many :assets, :as => :attachable, :dependent => :destroy
  has_many :logs, as: :commentable, class_name: "Comment"

  validates :name, :presence => true, :uniqueness => true,
    :format => { :with => /\A[A-Za-z0-9\s_-]+/ }
  validates :username, :presence => true
  validates :url, :presence => true,
    :format => {:with => /\Ahttps?:\/\/.*\z/}
  validates :password, :presence => true, :confirmation => true

  validate :validate_attachments
  has_paper_trail

  attr_protected :assets
  attr_accessible :name, :url, :username, :comments, :password, :versions, :updated_at
  attr_accessible :id, :encrypted_url, :encrypted_comments,
      :encrypted_password, :created_at, :label_ids, :password_confirmation
  Max_Attachments = 50
  Max_Attachment_Size = 5.megabyte

  def validate_attachments
    errors[:base] << "Too many attachments - maximum is #{Max_Attachments}" \
      if assets.length > Max_Attachments
    assets.each {|a|
      errors[:base] << "#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB" \
        if a.file_size > Max_Attachment_Size
    }
  end

  before_save { |a| a.name = a.name.upcase }
  cattr_reader :per_page
  @@per_page = 10

  # This function searches the accounts and returns a
  # paginated list ordered by +order_by+ parameter
  # ==== Parameters
  #
  # * <tt>:filter</tt> - Search expression
  # * <tt>:page</tt> - Page number used for paginate function
  # * <tt>:order_by</tt> - Ordering expression used for paginate function
  #
  def self.search(filter, page, order_by, no_page=nil)
    if filter
      begin
        if no_page.nil?
          where('name like ? or username like ?',
                    "%#{filter.upcase}%", "%#{filter}%").
            order(order_by).page(page)
        else
          where('name like ? or username like ?',
                "%#{filter.upcase}%", "%#{filter}%")
        end
      rescue ActiveRecord::RecordNotFound
        []
      end
    else
      order_by = 'updated_at desc' if order_by == ' '
      Account.order(order_by).page(page)
    end
  end

  #
  # Returns tab separated string for accounts suitable for csv/excel export
  #
  def self.to_csv(accounts)
    klass = 'CSV'
    if RUBY_VERSION < "1.9"
      klass = 'FasterCSV'
    end
    tsv_str = Object::const_get(klass).generate(:col_sep => "\t") do |tsv|
      tsv << ["Name", "URL", "User Name", "Password", "Comments"]
      accounts.each do |a|
        tsv << [
          a.name,
          a.url,
          a.username,
          a.password,
          a.comments
        ]
      end
    end
    tsv_str
  end

  # Creates a spreadsheet object using spreadsheet gem and returns #StringIO object
  # correspoding to it that can be directly used with send_data
  #
  # ==== Parameters
  # <tt>:account</tt> - Array of account objects to be exported
  #
  def self.to_xls(accounts)
    str_data = StringIO.new ''
    book = Spreadsheet::Workbook.new
    book.default_format = Spreadsheet::Format.new :text_wrap => false
    header_format = Spreadsheet::Format.new :weight => :bold
    sheet1 = book.create_worksheet
    sheet1.name = 'Accounting Worksheet'
    sheet1.row(0).default_format = header_format
    sheet1.row(0).push "Name", "URL", "User Name", "Password", "Comments"
    rnum = 1
    accounts.each do |a|
      sheet1.row(rnum).push(a.name, a.url, a.username, a.password, a.comments)
      rnum += 1
    end
    book.write str_data
    str_data.string.bytes.to_a.pack("C*")
  end
end
