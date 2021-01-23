class EventEntity < BaseEntity
  expose :name
  expose :date do |_|
    object.date.strftime('%Y-%m-%d')
  end
  expose :time do |_|
    object.time.strftime('%H:%M:%S')
  end
end
