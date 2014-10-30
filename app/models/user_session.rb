class UserSession < Authlogic::Session::Base
  # Fix
  include ActiveModel::Conversion
  def persisted?
    false
  end
  # End of fix 
end