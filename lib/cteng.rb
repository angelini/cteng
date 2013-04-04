require "eventmachine"
require "logger"
require "cteng/version"
require "cteng/engine"

module Cteng
  attr_accessor :engine, :log

  def initialize(folder)
    output = lambda do |str|
      send_data str
    end

    @log = Logger.new STDOUT
    @engine = Engine.new EM::Queue.new, folder, log, output
  end

  def post_init
    engine.init_queue
    log.info "Client connected"
  end

  def unbind
    log.info "Client disconnected"
  end

  def receive_data(data)
    engine.input data
  end
end

EventMachine.run {
  EM.start_server('0.0.0.0', 9000, Cteng, ARGV[0])
}
