class Friend < ActiveRecord::Base
  attr_accessible :uid, :name, :facebook_id, :attending

  def friends_attending
    @graph = Koala::Facebook::GraphAPI.new(facebook_cookies['access_token'])
    @friends = @graph.get_connections(:uid, 'friends')
    uids = @friends.collect(&:uid)

    MiniFB.fql(facebook_cookies['access_token'], SELECT uid, name FROM User WHERE uid IN (SELECT uid FROM :attending WHERE eid = :facebook_id AND uid IN (SELECT uid2 FROM uids WHERE uid1 = :uid))
  end
end
