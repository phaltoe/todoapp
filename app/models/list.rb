class List < ActiveRecord::Base
  validates_presence_of :name
  validates :name, length: {:minimum => 3}

  has_many :items
end
