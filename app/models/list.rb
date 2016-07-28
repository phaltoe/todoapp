class List < ActiveRecord::Base
  validates_presence_of :name
  validates :name, length: {:minimum => 3}

  has_many :items

  # accepts_nested_attributes_for :items, :reject_if => :all_blank

  def items_attributes=(attributes)
    attributes.each do |i, item_hash|
      self.items.build(item_hash)
    end
  end

end
