require 'active_support'
require 'active_support/core_ext'
require 'faraday'
require 'faraday_middleware'
require 'thor'

# Tasks for remote resources
class Resource < Thor
  include Thor::Actions

  class_option :dir, type: :string, desc: 'resource directory'

  desc 'fetch <name>', 'fetch resources'

  def fetch(name)
    url, path = resource_url(name)

    dir = File.join(options[:dir] || resource_dir || '.', name)

    inside dir, verbose: true do
      download(url, path, raw: true) do |res|
        File.open(File.basename(path), 'w') { |f| f.write res.body }
      end
    end
  end

  desc 'load <name>', 'load resources'

  def load(name)
    path, pattern, graph = resource_load_path(name)

    load_directory(path, pattern, graph)
  end

  private

  def resource_dir
    ENV['TOGOID_RESOURCE_DIR'].presence
  end

  def isql
    ENV['ISQL'].presence || 'isql'
  end

  def isql_host
    ENV['ISQL_HOST'].presence || 'localhost'
  end

  def isql_port
    ENV['ISQL_PORT'].presence || 1111
  end

  def isql_user
    ENV['ISQL_USER'].presence || 'dba'
  end

  def isql_password
    ENV['ISQL_PASSWORD'].presence || 'dba'
  end

  def resource_url(name)
    case name
    when 'hgnc'
      %w[https://github.com /med2rdf/hgnc/blob/master/hgnc_complete_set.ttl]
    else
      raise "Unknown name: #{name}"
    end
  end

  def resource_load_path(name)
    dir = File.join(options[:dir] || resource_dir || '.', name)

    case name
    when 'hgnc'
      %W[#{dir} *.ttl http://togoid.org/graph/hgnc]
    else
      raise "Unknown name: #{name}"
    end
  end

  def download(url, path, **params, &block)
    say("Download resource from #{[url, path].join}")

    conn = Faraday.new(url: url) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects
      faraday.adapter :net_http
    end

    response = conn.get do |req|
      req.url path, params
      req.headers['Content-type'] = 'text/plain'
    end

    yield response
  end

  # OpenLink Interactive SQL (Virtuoso), version 0.9849b.
  #
  #    Usage :
  # isql <HOST>[:<PORT>] <UID> <PWD> file1 file2 ...
  #
  # isql -H <server_IP> [-S <server_port>] [-U <UID>] [-P <PWD>]
  #      [-E] [-X <pkcs12_file>] [-K] [-C <num>] [-b <num>]
  #      [-u <name>=<val>]* [-i <param1> <param2>]
  #      isql -?
  # Connection options:
  #
  #   -?                  - This help message
  #   -U username         - Specifies the login user ID
  #   -P password         - Specifies the login password
  #   -H server_addr      - Specifies the Server address (IP)
  #   -S server port      - Specifies the TCP port to connect to
  #   -E                  - Specifies that encryption will be used
  #   -C                  - Specifies that password will be sent in cleartext
  #   -X pkcs12_file      - Specifies that encryption & X509 certificates will
  #                         be used
  #   -T server_cert      - Specifies that CA certificate file to be used
  #   -b size             - Specifies that large command buffer to be used
  #                         (in KBytes)
  #   -K                  - Shuts down the virtuoso on connecting to it
  #
  # Parameter passing options:
  #
  #   -u name1=val1... - Everything after -u is stored to associative array U,
  #                         until -i is encountered. If no equal sign then value
  #                         is NULL
  #   -i                  - Ignore everything after the -i option, after which
  #                         comes arbitrary input parameter(s) for isql procedure,
  #                         which can be referenced with $ARGV[$I] by the
  #                         ISQL-commands.
  #   <OPT>=<value>       - Sets the ISQL options
  #
  #   Note that if none of the above matches then the non-options go as
  #   <HOST>[:<PORT>] <UID> <PWD> file1 file2 ...
  def load_directory(path, pattern, graph)
    cmd = [isql]
    cmd << "#{isql_host}:#{isql_port}"
    cmd << "-U #{isql_user}"
    cmd << "-P #{isql_password}"
    cmd << "\"exec=ld_dir('#{path}', '#{pattern}', '#{graph}'); rdf_loader_run(); checkpoint;\""

    run(cmd.join(' '))
  end
end
