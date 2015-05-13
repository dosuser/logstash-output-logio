require "logstash/outputs/base"
require "logstash/namespace"
require "socket"

#Source was taken from: https://github.com/msmathers/logstash/blob/develop/log.io/lib/logstash/outputs/logio.rb
# Log.io Output
#
# Sends events to a Log.io server over TCP.
#
# Plugin is fault tolerant.  If the plugin is unable to connect to the server,
# or writes to a broken socket, it will attempt to reconnect indefinitely.
#
# This logstash plugin was converted to a gist by Luke Chavers <github.com/vmadman>
# Source was taken from: https://github.com/msmathers/logstash/blob/develop/log.io/lib/logstash/outputs/logio.rb
# See also: http://narrativescience.com/blog/announcing-the-new-log-io/
#
class LogStash::Outputs::LogIO < LogStash::Outputs::Base

  config_name "logio"
  plugin_status 0

  # log.io server host
  config :host, :validate => :string, :required => true

  # log.io server TCP port
  config :port, :validate => :number, :default => 28777
  
  # log.io TCP message format
  config :format, :default => "%{message}"

  public
  def register
    connect
  end

  public
  def receive(event)
    return unless output?(event)
    msg = event.sprintf("+log|%{path}|%{host}||"+@format+"\r\n")
    send_log(msg)
  end

  private
  def connect
    begin
      @sock = TCPSocket.open(@host, @port)
    rescue
      sleep(2)
      connect
      # this code is harmful in huge system. must to be changed.
    end
  end

  private
  def send_log(msg)
    begin
      @sock.puts msg
    rescue
      sleep(2)
      connect
      # this code is harmful in huge system. must to be changed.
    end
  end
end