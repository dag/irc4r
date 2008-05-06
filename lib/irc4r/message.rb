module IRC4R
  class Message
    attr_accessor :source, :command, :params

    def initialize(string_or_hash=nil)
      case string_or_hash
      when String
        from_string(string_or_hash)
      when Hash
        @source = string_or_hash[:source] if string_or_hash.include? :source
        @command = string_or_hash[:command] if string_or_hash.include? :command
        @params = string_or_hash[:params] if string_or_hash.include? :params
      end
    end

    def to_s
      src = ":#@source " if @source
      args = " " + @params[0..-2].join(" ") if @params.length > 1
      data = " :" + @params.last unless @params.empty?
      "%s%s%s%s\r\n" % [src, @command.to_s.upcase, args, data]
    end

    private

    def from_string(string)
      string = string.chomp
      tokens = string.split(" ")
      if string[0] == ?:
        @source = tokens[0][1..-1]
        @command = tokens[1]
        tokens = string.split(":")
        @params = tokens[1].split(" ")[2..-1] if tokens.size > 1
        @params << string[string.index(":", 1)+1..-1] if tokens.size > 2
      else
        @command = tokens[0]
        tokens = string.split(":")
        @params = tokens[0].split(" ")[1..-1] if tokens.size > 0
        @params << string[string.index(":")+1..-1] if tokens.size > 1
      end
    end
  end
end
