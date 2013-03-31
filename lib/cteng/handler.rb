class Handler
  def initialize(state)
    @state = state
  end

  def handle(fn, args)
    all_args = [@state] + args
    fn.call(*all_args)
  end
end
