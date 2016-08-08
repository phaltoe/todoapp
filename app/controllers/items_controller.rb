class ItemsController < ApplicationController
  def new
  end

  def create
    @list = List.find(params[:list_id])
    @item = @list.items.build(item_params)
    @list.save
    redirect_to @list
  end

  private

  def item_params
    params.require(:item).permit(:description)
  end

end
