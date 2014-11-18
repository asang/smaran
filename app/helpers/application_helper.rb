module ApplicationHelper
  # Sortable columns helper. Taken from http://asciicasts.com/episodes/228-sortable-table-columns
  def sortable(column, model, title = nil)
    title ||= column.titleize
    if controller.is_a?(AccountsController)
      title = title + ' '
      sc = sort_column(model)
      sd = sort_direction
      css_class = (column == sc) ? "current #{sd.downcase}" : nil
      direction = (column == sc && sd == "ASC") ? "DESC" : "ASC"
      link_to title, params.merge(:sort => column, :direction => direction, :page => nil),
          :class => css_class, :remote => true
    else
      title
    end
  end

  def table_class
    html = "table table-striped"
    if !controller.is_a?(AccountsController)
      html << "table table-striped sortable"
    end
	html
  end

  # Returns the value of serial number after taking "page" number into account
  def serial_number(index)
    if not params[:page].blank?
      if params[:page].to_i >= 1
        (index + 1) + (params[:page].to_i - 1) * Account.per_page
      end
    else
      index + 1
    end
  end
end
