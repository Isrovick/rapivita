class Conv < ApplicationRecord
  belongs_to :curto, :class_name =>'Curr'
  belongs_to :curfr, :class_name =>'Curr'
end
