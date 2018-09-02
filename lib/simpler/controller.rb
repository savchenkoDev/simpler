require_relative 'view'

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      send(action)
      write_response
      set_default_headers

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      if @request.env['simpler.template'].is_a?(Hash)
        return @response['Content-Type'] = case @request.env['simpler.template'].first[0]
                                    when :plain then 'text/plain'
                                    else 'text/html'
                                    end
      end
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def headers(hash)
      hash.each_pair { |key, value| header(key, value) }
    end

    def header(key, value)
      @response[key.to_s] = value.to_s
    end

    def status(status)
      @response.status = status
    end
  end
end
