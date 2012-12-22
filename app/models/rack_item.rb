class RackItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :album
  attr_accessible :evaluation, :review
end
