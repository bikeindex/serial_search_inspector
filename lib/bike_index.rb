class Error < StandardError
end

module BikeIndex
  class Client < OAuth2::Client
    def initialize
      super(
        ENV['BIKEINDEX_APP_ID'],
        ENV['BIKEINDEX_APP_SECRET'],
        site: ENV['BIKE_INDEX_URL']
      )
    end
  end

  class Token < OAuth2::AccessToken
    def initialize(user)
      super(
        BikeIndex::Client.new,
        user.binx_credentials['token'],
        refresh_token: user.binx_credentials['refresh_token'],
        expires_at: user.binx_credentials['expires_at']
      )
    end
  end

  class Requester
    include HTTParty
    base_uri 'https://bikeindex.org/api/v3'

    def initialize(user = nil)
      @user = user if user.present?
    end

    def request_bikes
      make_get_request
    end

    def make_get_request
      response = self.class.get("/me/bikes?access_token=#{access_token}")
      JSON.parse(response.body)
    end

    def request_bike_by_bike_index_id(bike_index_id)
      response = self.class.get("/bikes/#{bike_index_id}")
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
end
