class ListsController < ApplicationController
  

  def show
    @list = List.find(params[:id])
  end

  def index
    @lists = List.all
  end

  def new
  end

  def edit
  end

  def update
  end

  def create
    @list = List.new
    @list.name = params[:list][:name]
    @list.save

    redirect_to list_path(@list.id)
  end

  def destroy
  end
end
