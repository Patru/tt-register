class StaticController < ApplicationController
  before_filter :admin_required, :except => :show
  def show
    guess_tournament
    not_found if params[:page_id].nil?
    case params[:page_id]
      when 'help'
        help
      else
        not_found
    end
  end

private
  def not_found
    render :not_found
  end

  def help
    render :help
  end
end
