require "eventmachine"
require "cteng/version"
require "cteng/main"

module Cteng
  Main = ::Main
end

EventMachine.run {
  q = EM::Queue.new
  EM.start_server('0.0.0.0', 9000, Cteng::Main, q, ARGV[0])
}
