require 'irc4r/message'
require 'thread'
require 'socket'

module IRC4R
  class Client
    attr_reader :user, :real, :nick, :server, :port, :io, :socket, :thread

    def initialize(opts={})
      opts.each {|k, v| instance_variable_set "@#{k}".to_sym, v }
      @user ||= "irc4r"
      @real ||= "IRC for Ruby"
      @nick ||= "irc4r"
      @port ||= 6667
      @io ||= TCPSocket
    end

    def connect
      @socket = @io.open(@server, @port)
      @thread = Thread.new { read_socket }
      send :user, @user, ".", ".", @real
      send :nick, @nick
      self
    end

    def send(command, *params)
      msg = Message.new(:command => command, :params => params)
      signalize :outgoing, msg
      @socket.write(msg)
    end

    private

    def signalize(name, *args)
      __send__(name, *args) if respond_to? name
    end

    def read_socket
      while msg = Message.new(@socket.readline)
        signalize :incoming, msg
        case msg.command.to_s.downcase
        when "ping"
          send :pong, msg.params[0]
          signalize :on_ping, msg.params[0]
        when "001"
          signalize :on_connect
        when "privmsg"
          signalize :on_message, msg.source, *msg.params
        end
      end
    end
  end
end
