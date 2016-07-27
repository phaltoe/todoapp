class List < ActiveRecord::Base
  validates_presence_of :name
  validates :name, length: {:minimum => 3}

  has_many :items

  def item_attributes=(items_array)
    items_array.each do |item_hash|
      self.items.build(items_array) #is equivalent the same as lines 10-12
      # self.items.build do |item|
      #   item.description = [:item_hash].description
      #   item.priority = [:item_hash].priority
    end
  end

end
