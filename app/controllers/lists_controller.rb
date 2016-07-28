class ListsController < ApplicationController
  

  def show
    @list = List.find(params[:id])
  end

  def index
    @lists = List.all
  end

  def new
    @list = List.new
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    @list.update(list_params)
    redirect_to list_path(@list.id)
  end

  def create
    @list = List.new(list_params)

    if @list.valid?
      @list.save
      redirect_to list_path(@list.id)
    else
      render :new
    end
  end

  def destroy
  end

  private

  def list_params
    params.require(:list).permit(:name, :items_attributes => [:description, :priority])
  end
end
