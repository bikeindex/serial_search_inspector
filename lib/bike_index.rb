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
end
