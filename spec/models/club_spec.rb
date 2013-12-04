require 'spec_helper'

def fake_search(name, payload)
    url = URI.escape("http://api.berkeley.edu/callink/CalLinkOrganizations?name=#{name}&type=&category=&status=&excludeHiddenOrganizations=&organizationId=&app_id=#{ENV['CALLINK_APP_ID']}&app_key=#{ENV['CALLINK_API_KEY']}")
    FakeWeb.register_uri(:get, url, :body =>  payload, :content_type => 'text/xml; charset=utf-8')
end

describe Club do
    context "before_validation" do
        let(:club_with_duplicate_urls){ Club.new(:facebook_url => "http://facebook.com/ucbcalibetas http://facebook.com/ucbcalibetas http://facebook.com/ucbcalibetas http://facebook.com/ucbcalibetas http://facebook.com/ucbcalibetas") }
        it "cleans facebook_url" do
            club_with_duplicate_urls.valid?
            expect(club_with_duplicate_urls.facebook_url).to eq("http://facebook.com/ucbcalibetas")
        end
    end
    all = File.open( Rails.root.join("spec/callink-api-group-all.xml"), "r").read
    let(:all){ all }
    fake_search( nil, all)

    ieee = File.open( Rails.root.join("spec/callink-api-group-IEEE.xml"), "r").read
    let(:ieee){ ieee }
    fake_search("IEEE", ieee)
    ieee_parsed = Club.send(:parse_callink_orgs, Callink::Organization.search(:name => "IEEE")) 
    let(:ieee_parsed){ ieee_parsed }

    innod = File.open( Rails.root.join("spec/callink-api-group-Innovative+Design.xml"), "r").read
    let(:innod){ innod }
    fake_search("Innovative Design", innod)
    let(:innod_parsed){ Club.send(:parse_callink_orgs, Callink::Organization.search(:name => "Innovative Design")) }

    search_berkeley = File.open( Rails.root.join("spec/callink-api-group-search-Berkeley.xml"), "r").read
    let(:search_berkeley){ search_berkeley }
    fake_search("Berkeley", search_berkeley)
    search_berkeley_parsed = Club.send(:parse_callink_orgs, Callink::Organization.search(:name => "Berkeley"))
    let(:search_berkeley_parsed){ search_berkeley_parsed }

    subject(:club){ FactoryGirl.create(:club) }

    jsa = File.open( Rails.root.join("spec/callink-api-group-GA-Boalt-JSA.xml"), "r").read
    let(:jsa){ jsa }
    fake_search("dupe - GA Boalt Jewish Students Association", jsa)
    jsa_parsed = Club.send(:parse_callink_orgs, Callink::Organization.search(:name => "dupe - GA Boalt Jewish Students Association"))
    let(:jsa_parsed){ jsa_parsed }



  describe "#create_or_update_category" do
    it "should not create category if one with name exists" do
        expect(club.categories).to have(0).items
        2.times{
            club.create_or_update_category({ name: "Cool"})
            expect(club.reload.categories).to have(1).items
        }
    end
  end

  describe "Club.sync_callink_groups" do
    it { Club.sync_callink_groups; expect(Club.count).to eq(2104)}
    it "should not make duplicate clubs" do
        2.times{ Club.sync_callink_groups }
        expect(Club.count).to eq(2104)
    end
    context "self.save_callink_org_hash" do
        it "should save facebook url if exists" do
            Club.save_callink_org_hash(innod_parsed[0])
            club = Club.first
            expect(Club.count).to eq(1)
            expect(club.facebook_url).to be_present
        end
        it "should not create a club with a matching callink_id" do
            (1..2).to_a.each{ |i|
                Club.save_callink_org_hash({ 'OrganizationId' => 1, 'Description'=> nil, 'Name' => "Name_#{i}", 'FacebookUrl' => nil, 'Categories' => {"Category" => {"CategoryId"=>"5102", "CategoryName"=> "ASUC Government Programs"}} })
                expect(Club.count).to eq(1)
            }
        end
        context "save categories " do
            it do
                Club.save_callink_org_hash(ieee_parsed[0])
                expect(Club.count).to eq(1)
                expect(Club.first.categories).to have(1).items
            end
            it "should handle no categories" do
                Club.save_callink_org_hash(jsa_parsed[0])
                expect(Club.count).to eq(1)
                expect(Club.first.categories).to have(0).items
            end
        end
    end
    context "self.parse_callink_orgs" do
        it "should return an array of organizations" do
            expect(ieee_parsed).to be_instance_of(Array)
            expect(ieee_parsed).to have(1).items

            expect(search_berkeley_parsed).to be_instance_of(Array)
            expect(search_berkeley_parsed).to have(492).items
        end
    end
  end
end
