require "eventmachine"
require "cteng/version"
require "cteng/main"

module Cteng
  Main = ::Main
end

EventMachine.run {
  EM.start_server('0.0.0.0', 9000, Cteng::Main, ARGV[0])
}
