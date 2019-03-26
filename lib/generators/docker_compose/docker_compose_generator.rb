class DockerComposeGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  class_option :env, aliases: '-e', type: :string

  def copy_yaml
    env = options[:env] || ENV['RAILS_ENV'] ||= ENV['RACK_ENV'] || 'development'
    template "#{env}.yml", File.join(Rails.root, 'docker-compose.yml')
  end
end
