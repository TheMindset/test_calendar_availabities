class Event < ActiveRecord::Base
  
  validates :starts_at, :ends_at, :kind, presence: true
  validates :kind, inclusion: { in: ['opening', 'appointment'] }

  def self.availabilities(date)
    calendar = []
    calendar << { date: date, slots: [] }
    6.times do
      calendar << { date: date += 1, slots: check_slots(date) }
    end
    calendar
  end

  def self.check_slots(date)
    open_slot = Event.where("(starts_at >= ? OR weekly_recurring = ?) AND kind = 'opening'", date, true)
    close_slot = Event.where("(starts_at >= ? OR weekly_recurring = ?) AND kind = 'appointment'", date, true)

    open_list = []
    close_list = []
    time_slot = 30.minutes
    
    open_slot.each do |slot|
      while slot.starts_at < slot.ends_at do
        open_list << slot.starts_at.strftime('%k:%M').strip
        slot.starts_at += time_slot
      end
    end

    close_slot.each do |slot|
      while slot.starts_at < slot.ends_at do
        close_list << slot.starts_at.strftime('%k:%M').strip
        slot.starts_at += time_slot
      end
    end

    free_slots = open_list - close_list
    free_slots
  end

end