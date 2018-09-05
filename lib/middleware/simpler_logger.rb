require 'logger'

module Middleware
  class SimplerLogger
    def initialize(app, _logger)
      @app = app
      @logger = Logger.new(File.expand_path('log/app.log', __dir__) || STDOUT)
    end

    def call(env)
      @app.call(env).tap do |response|
        controller = env['simpler.controller']
        handler = "#{controller.class.name}##{env['simpler.action']}"
        status, headers = *response
        @logger.info "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}"
        @logger.info "Handler: #{handler}"
        @logger.info "Params:  #{env['QUERY_STRING']}"
        @logger.info "Response: #{status} #{headers['Content-Type']} #{env['simpler.template']}"
      end
    end
  end
end
