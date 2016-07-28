class List < ActiveRecord::Base
  validates_presence_of :name
  validates :name, length: {:minimum => 3}

  has_many :items

  accepts_nested_attributes_for :items

  # def item_attributes=(attributes)
  #   items_array.each do |index, item_hash|
  #     self.items.build(item_hash) #is equivalent the same as lines 10-12
  #     # self.items.build do |item|
  #     #   item.description = [:item_hash].description
  #     #   item.priority = [:item_hash].priority
  #   end
  # end

end
