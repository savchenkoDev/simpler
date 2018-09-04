class TestsController < Simpler::Controller

  def index
    @time = Time.now
    header('params', params)
  end

  def create; end

  def show
    header('params', params)
  end

end
