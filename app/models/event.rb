class Event < ApplicationRecord
  has_many :ticket_types, dependent: :destroy
end
