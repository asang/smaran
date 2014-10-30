module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /home page/
      root_path   
    when /login page/
      new_user_session_path
    when /account page/
        account_path(@account)
    else
      if path = match_rails_path_for(page_name) 
        path
      else 
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
      end
    end
  end

  def match_rails_path_for(page_name)
    if page_name.match(/(.*) page/)
      return send "#{$1.gsub(" ", "_")}_path" rescue nil
    end
  end
end

World(NavigationHelpers)