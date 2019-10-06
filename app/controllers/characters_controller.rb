class CharactersController < ApplicationController

  protect_from_forgery :except => [:import]

  def index

  end

  def import
    Character.import(params[:file])
    redirect_to characters_path, notice: "Characters added successfully!!"
  end 

end