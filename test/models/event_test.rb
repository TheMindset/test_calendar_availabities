require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    @event = Event.create kind: 'Hercule', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    @invalid_event = Event.create kind: 'opening' , starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: "" , weekly_recurring: true
  end
  test "one simple test example" do
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")

    availabilities = Event.availabilities DateTime.parse("2014-08-10")

    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length
  end


  test "should validates kind of events" do
    refute @event.valid?
  end

  test "should validates input presence" do
    assert @invalid_event.errors.messages.include?(:ends_at)
  end
end
