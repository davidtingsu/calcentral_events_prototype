class Club < ActiveRecord::Base
  has_many :events 
  attr_accessible :description, :name, :facebook_id, :facebook_url, :callink_id, :callink_permalink
  has_many :categories
  scope :with_facebook_url, ->(){ where("facebook_url IS NOT NULL") }
  scope :facebook, ->(){ where("facebook_id IS NOT NULL") }
  scope :callink, ->(){ where("callink_id IS NOT NULL") }

  def is_facebook?
    facebook_id.present?
  end

  def set_facebook_id!
    if facebook_url.present?
      id = Event.facebookIDFromFacebookPageUrl(facebook_url)
      self.update_attribute(:facebook_id, id) if /^\d+$/.match(id)
    end
  end

  def is_callink?
    callink_id.present?
  end

  def update_events!
    # gets and creates association with for facebook page events
    # TODO: get events for facebook groups when user access token present
    # There is currently no direct way a callink clubs
    if is_facebook?
        events = Event.getFacebookEvents(facebook_id)
        events.each{ |event_hash|
            update_or_create_facebook_event(event_hash)
        }
    end
  end

  def get_facebook_group_events(user_access_token)
    MiniFB.get(user_access_token, facebook_id , :type => "events") if (facebook_id and user_access_token != " ")
  end

  def self.sync_callink_groups
    response = Callink::Organization.search
    orgs = parse_callink_orgs(response) if response.ok?
    orgs.each{ |org| save_callink_org_hash(org) } if orgs.present?
  end

  def create_or_update_category(attributes)
    unless attributes[:name].blank?
        category ||= Category.find_by_callink_id(attributes[:callink_id])
        category ||= Category.find_by_name(attributes[:name])
        category ||= Category.create(attributes)
        category.update_attributes!(attributes)
        categories << category unless categories.include? category
        category
    end
  end

  private
  def self.parse_callink_orgs(response)
    [ response['ResultOfOrganization']["Items"] ].flatten.map{ |org| org["Organization"] }.flatten
  end

  def self.parse_categories(org_hash)
    categories = [ org_hash['Categories'] ].flatten.compact.map{|category| category['Category']}.flatten
    categories.map{|category| { callink_id: category['CategoryId'], name: category['CategoryName']} }
  end

  def self.save_callink_org_hash(hash)
    permalink_match = /organization\/(.*)/.match(hash['ProfileUrl'])
    callink_permalink ||= permalink_match[1] if permalink_match

    club ||= Club.find_by_callink_id(hash['OrganizationId'])
    club ||= Club.create({ callink_id: hash['OrganizationId'], description: hash['Description'], name: hash['Name'], facebook_url: hash['FacebookUrl']})

    club.update_attributes!({
        description: hash['Description'],
        name: hash['Name'],
        facebook_url: hash['FacebookUrl'],
        callink_id: hash['OrganizationId'],
        callink_permalink: callink_permalink
    })

    categories =  Club.parse_categories(hash)
    categories.each{ |category_attributes|
        club.create_or_update_category category_attributes
    }

    club
  end
  def update_or_create_facebook_event(event_hash, only_future = true)
    event ||= Event.find_by_facebook_id(event_hash.eid)
    event ||= Event.new(:name => event_hash.name, :start_time => event_hash.start_time, :end_time => event_hash.end_time, :description => event_hash.description)
    events << event and save! if (only_future and event.start_time.future?) or ! only_future
  end

end
