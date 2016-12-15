class BikeIndex::Requester
  include HTTParty
  base_uri 'https://bikeindex.org/api/v3'

  def initialize(user = nil)
    @user = user if user.present?
  end

  def get_bikes
    get_request
  end

  def get_request
    response = self.class.get("/me/bikes?access_token=#{access_token}")
    JSON.parse(response.body)
  end

  def refreshed_token(token)
    token = token.refresh!
    cred = {
      token: token.token,
      refresh_token: token.refresh_token,
      expires_at: token.expires_at,
      expires: true
    }
    @user.update_attribute :binx_credentials, cred
    token
  end

  def access_token
    token = BikeIndex::Token.new(@user)
    token = refreshed_token(token) if token.expired?
    raise Error, 'User must re-auth error' unless token.present?
    token.token
  end
end
