module IRC4R
  class Channel
    attr_accessor :name, :topic, :users
    alias to_s name

    def initialize(name)
      @name = name
      @users = []
    end
  end
end
