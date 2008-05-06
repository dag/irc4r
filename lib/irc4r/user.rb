module IRC4R
  class User
    attr_accessor :nick, :user, :host, :real, :channels

    def initialize(address)
      address = address.to_s.split("@")
      @nick, @user = address[0].to_s.split("!")
      @host = address[1]
      @channels = []
    end
  end
end
