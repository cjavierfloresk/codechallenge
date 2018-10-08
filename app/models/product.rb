class Product
  include Mongoid::Document
  field :name, type: String
  field :product_type, type: String
  field :length, type: Integer
  field :width, type: Integer
  field :height, type: Integer
  field :weight, type: Integer

  validates :name, presence: true
  validates :product_type, presence: true
  validates :length, presence: true
  validates :width, presence: true
  validates :height, presence: true
  validates :weight, presence: true
  
  validates :length, numericality: true
  validates :width, numericality: true
  validates :height, numericality: true
  validates :weight, numericality: true


  #scope :le, ->(val){ where(:length => val) }
  #scope :wi, ->(val){ where(:width => val) }
  #scope :he, ->(val){ where(:height => val) }
  #scope :we, ->(val){ where(:weight => val) }

  scope :le, ->(val){ where(:length.gte => val) }
  scope :wi, ->(val){ where(:width.gte => val) }
  scope :he, ->(val){ where(:height.gte => val) }
  scope :we, ->(val){ where(:weight.gte => val) }
end