# logstash-output-logio
logstash 3rd party output library for logio


# logstash-output-logio
logstash 3rd party output library for logio

# install 
deploy 'logio.rb' file to ${logstash_path}/lib/logstash/output/

# configuration
output {
  logio {
    host => ... # server host (requred)
    port => ....# server port (optional), default : 28777
    format => ... # format (optional), default : %{message}
  }
}

# example
input {
        file {
                path => "/home1/irteam/logs/service/async.log"
        }
        file {
                path => "/home1/irteam/logs/service/news.log"
        }
}

output {
        logio {
                host => "www.google.com"
                port => 28777
        }
        stdout { }
}
