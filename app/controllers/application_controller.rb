class ApplicationController < ActionController::Base

  def paged(records, per = 10)
    records.page(params[:page] || 1).per(per)
  end

end
