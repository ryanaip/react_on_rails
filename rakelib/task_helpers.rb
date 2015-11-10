module ReactOnRails
  module TaskHelpers
    # Returns the root folder of the react_on_rails gem
    def gem_root
      File.expand_path("../../.", __FILE__)
    end

    # Returns the folder where examples are located
    def examples_dir
      File.join(gem_root, "examples")
    end

    def dummy_app_dirs
      %w(spec/dummy spec/dummy-react-013).map { |rel_dir| File.join(gem_root, rel_dir) }
    end

    # Executes a string of shell commands, one on each line, one at a time
    # after first "cd"ing into the specified directory.
    def sh_in_dir(dir, shell_commands)
      shell_commands.each_line { |shell_command| sh %(cd #{dir} && #{shell_command.strip}) }
    end

    # Needs to use the --system flag to override TravisCI's --deployment setting
    # which screws everything up since we have multiple Gemfiles in nested
    # directories.
    def bundle_install_in(dir)
      sh_in_dir(dir, "bundle install --gemfile=Gemfile --path=$GEM_HOME  --no-frozen")
    end

    # Runs bundle exec using that directory's Gemfile
    def bundle_exec(dir:, args:, env_vars: "")
      # TODO
      # Bundler.with_clean_env do
      #   Dir.chdir dir do
      #     `#{env_vars} bundle exec #{args} --gemfile=Gemfile`
      #   end
      # end
      sh_in_dir(dir, "#{env_vars} bundle exec #{args} --gemfile=Gemfile")
    end

    # `dir` a directory containing a package.json file
    def build_webpack_bundles(dir:, server_rendering:)
      sh_in_dir(dir, "npm install")

      shell_commands = "webpack --config webpack.client.rails.config.js"
      shell_commands << "webpack --config webpack.rails.server.config.js" if server_rendering
      sh_in_dir(dir, shell_commands)
    end
  end

  # The version of node to install (used by CI)
  def node_version
    "4.2.0"
  end
end
