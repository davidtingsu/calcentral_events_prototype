class User < ActiveRecord::Base
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid, :facebook_pic_square
  after_initialize :set_facebook_pic_square!, :if => lambda{|user| ( ! user.new_record? ) and user.facebook_pic_square.blank?}

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
  def  set_facebook_pic_square!
    if oauth_expires_at.future?
        begin
        response = MiniFB.fql(oauth_token, "SELECT pic_square from user where uid = me() LIMIT 1")
        update_attribute(:facebook_pic_square, response.first.pic_square)
        rescue => e
            #TODO: handle error.
        end
    end
  end


end
