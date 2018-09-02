require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = template_path.is_a?(Hash) ? template_path.first[1] : File.read(template_path)

      ERB.new(template).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      return path if template.is_a?(Hash)
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def set_content(path)
      path.first[1]
    end
  end
end
