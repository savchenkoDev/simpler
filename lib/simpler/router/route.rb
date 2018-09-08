module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @path_arr = path.split('/').reject { |item| item == '' }
        @controller = controller
        @action = action
      end

      def match?(env)
        env['simpler.route_params'] = ''
        counter = 0
        method = env['REQUEST_METHOD'].downcase.to_sym
        path = env['PATH_INFO']
        if @method == method
          return true if path == @path
          path = path.split('/').reject { |item| item == '' }
          @path_arr.each_with_index do |value, index|
            if value[0] == ':'
              counter += 1
              env['simpler.route_params'] += "#{value[1..-1]}=#{path[index]}"
            end
          end
          !counter.zero?
        end
      end
    end
  end
end
