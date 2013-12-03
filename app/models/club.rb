class Club < ActiveRecord::Base
  has_many :events 
  attr_accessible :description, :name, :facebook_id, :facebook_url, :callink_id, :callink_permalink
  has_many :categories
  def get_facebook_group_events(user_access_token)
    MiniFB.get(user_access_token, facebook_id , :type => "events") if (facebook_id and user_access_token != " ")
  end

  def self.sync_callink_groups
    orgs = parse_callink_orgs(Callink::Organization.search)
    orgs.each{ |org| save_callink_org_hash(org) }
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
    club ||= Club.find_by_callink_id(hash['OrganizationId'])
    club ||= Club.create({ callink_id: hash['OrganizationId'], description: hash['Description'], name: hash['Name'], facebook_url: hash['FacebookUrl']})

    club.update_attributes!({
        description: hash['Description'],
        name: hash['Name'],
        facebook_url: hash['FacebookUrl'],
        callink_id: hash['OrganizationId']
    })

    categories =  Club.parse_categories(hash)
    categories.each{ |category_attributes|
        club.create_or_update_category category_attributes
    }

    club
  end
end
