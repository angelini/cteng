require "rake"
require "rake/testtask"

server = File.dirname(__FILE__) + '/lib/cteng.rb'
client = File.dirname(__FILE__) + '/lib/client/client.rb'
extensions = File.dirname(__FILE__) + '/extensions'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

task :clear_tmux, :server_pane, :client_pane do |t, args|
  `tmux send-keys -t #{args[:server_pane]} C-c`
  `tmux send-keys -t #{args[:client_pane]} C-c`
end

task :tmux, [:server_pane, :client_pane] => :clear_tmux do |t, args|
  `tmux send-keys -t #{args[:server_pane]} "bundle exec ruby #{server} #{extensions}" Enter`
  sleep 1
  `tmux send-keys -t #{args[:client_pane]} "bundle exec ruby #{client}" Enter`
end
