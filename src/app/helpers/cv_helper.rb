module CvHelper

  def check_date_validation(start_date, finish_date = nil)
    return true if finish_date.nil?
    return finish_date > start_date
  end

end
