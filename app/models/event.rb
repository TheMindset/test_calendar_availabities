class Event < ActiveRecord::Base
  
  def self.availabilities(date)
    availaible = [
      {date: date, slots: []}
    ]
  end
end
