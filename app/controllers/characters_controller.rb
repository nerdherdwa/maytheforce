class CharactersController < ApplicationController

  protect_from_forgery :except => [:import]

  def index

    (@filterrific = initialize_filterrific(
      Character,
      params[:filterrific],
      select_options: {
        sorted_by: Character.options_for_sorted_by,
      },
    )) || return

    @characters = paged(@filterrific.find.page(params[:page]))

    respond_to do |format|
      format.html
      format.js
    end
    
  end

  def import
    Character.import(params[:file])
    redirect_to characters_path, notice: "Characters added successfully!!"
  end 

end