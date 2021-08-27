class Balance < ApplicationRecord
  belongs_to :user
  belongs_to :curr
end
