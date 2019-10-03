class Event < ActiveRecord::Base
  
  def self.availabilities(date)
    calendar = [
      {date: date, slots: []}
    ]
    6.times { calendar << {date: date += 1, slots: []} }
    calendar
  end
end
