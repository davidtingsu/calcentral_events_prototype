require 'spec_helper'

describe Event do
    describe "Event.getCallinkEvents" do
        FakeWeb.register_uri(:get, 'https://callink.berkeley.edu/EventRss/EventsRss', :body => File.open(Rails.root.join('spec','EventsRss.rss'), "r").read)
        it "should create a list of event hashes with start_time and end_time" do
            events = Event.getCallinkEvents
            events.should have(14).items
            events.each{|event|
                event.should have_key(:start_datetime)
                event.should have_key(:start_date)
                event.should have_key(:start_time)
                event.should have_key(:end_time)
                expect((event[:start_datetime].present?) || (event[:start_date].present? && event[:start_time].present?)).to eq(true)
                event[:end_time].should be_present
            }
        end
        it "should create a list of event hashes with groupname, location, category, title, id, link, and description" do
            events = Event.getCallinkEvents
            events.each{|event|
                event.should have_key(:groupname)
                event[:groupname].should be_present

                event.should have_key(:groupname)
                event[:location].should be_present

                event.should have_key(:location)
                event[:location].should be_present
                
                event.should have_key(:category)
                #not all events have a category but the key should still be there

                event.should have_key(:title)
                event[:title].should be_present

                event.should have_key(:id)
                event[:id].should be_present

                event.should have_key(:link)
                event[:link].should be_present

                event.should have_key(:description)
                event[:description].should be_present

            }
        end
        context "Event.parse_time_from_description" do
            it "should parse times with date and time as separate components" do
                hash = Event.send(:parse_time_from_description, File.open( File.join(File.expand_path(File.dirname(__FILE__)), "..", 'description_with_start_time_as_2_components.xml')).read)
                hash.should have_key(:start_datetime)
                hash[:start_datetime].should be_nil
                hash.should have_key(:start_date)
                hash[:start_date].should eq("2013-11-17")
                hash.should have_key(:start_time)
                hash[:start_time].should eq("16:30:00")
                hash.should have_key(:end_time)
                hash[:end_time].should eq("18:30:00")
                hash.should have_key(:location)
                hash[:location].should eq("Upper Sproul")

            end
            it "should parse times with just one datetime component" do
                hash = Event.send(:parse_time_from_description, File.open( File.join(File.expand_path(File.dirname(__FILE__)), "..", 'description_with_start_time_as_1_component.xml')).read)
                hash.should have_key(:start_datetime)
                hash[:start_datetime].should eq("2013-11-18T19:00:00")
                hash.should have_key(:start_date)
                hash[:start_date].should be_nil
                hash.should have_key(:start_time)
                hash[:start_time].should be_nil
                hash.should have_key(:end_time)
                hash[:end_time].should eq("2013-11-18T21:00:00")
                hash.should have_key(:location)
                hash[:location].should eq("Andersen Auditorium, Haas School of Business")
            end
        end
    end
end
