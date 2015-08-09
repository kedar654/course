require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SectionsHelper. For example:
#
# describe SectionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe SectionsHelper do
  context "Time Taken" do
    context "timerange" do
      it "equals 125 when time is 2:05:00 AM" do
        expect(timerange("2:05:00 AM")).to eq(125)
      end

      it "equals 720 when time is 12:00:00 PM" do
        expect(timerange("12:00:00 PM")).to eq(720)
      end

      it "equals 0 when time is 12:00:00 AM" do
        expect(timerange("12:00:00 AM")).to eq(0)
      end
    end

    context "conflict time" do
      def conflict_expectation(days, stime, etime, expectation, time_slot_params)
        ts = TimeSlot.create(time_slot_params)
        t_range = get_range_times(stime, etime)

        expect(has_conflict?(ts, days, t_range)).to eq(expectation)
      end

      context "returning false" do
        it "occurs when comparing 'MWF' 2:00:00 PM - 3:00:00 PM to TR 2:30:00 pm - 4:50:00 PM" do
          conflict_expectation("MWF".split(""), "2:00:00 PM", "3:00:00 PM", false, days: "TR", start_time: "2:30:00 PM", end_time: "4:50:00 PM")
        end
      end
    end
  end
end
