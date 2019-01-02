class HomeController < ApplicationController
  def index
    @job_id = cookies.signed["job"] || 1
  end

  def update
    @job_id = params[:job][:id].to_i
    cookies.signed["job"] = @job_id
    render partial: 'equipset_partial'
  end
end