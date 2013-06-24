module FannyPack
  # Deal with bundling Sprocket assets into environments (like Rails or Sprockets)
  module Assets
    def self.path(*segs)
      File.join File.expand_path('../../assets', __FILE__), segs
    end

    # Integrate FannyPack ./lib/assets files into a sprocket-enabled environment.
    module Sprockets
      # Drop flash and javascript paths to FannyPack assets into a sprockets environment.
      def self.configure(env)
        env.append_path FannyPack::Assets.path('javascripts')
        env
      end

      # Try to automatically configure Sprockets if its detected in the project.
      def self.auto_detect
        if defined? ::Sprockets and ::Sprockets.respond_to? :append_path
          FannyPack::Assets::Sprockets.configure ::Sprockets
        end
      end
    end
  end
end
