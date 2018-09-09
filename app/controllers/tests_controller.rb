class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: "test"
  end

  def create; end

  def show; end

end
