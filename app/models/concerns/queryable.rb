module Queryable
  extend ActiveSupport::Concern

  module ClassMethods
    ##
    # Returns the SPARQL client
    #
    # @return [SPARQL::Client]
    def client
      @client ||= SPARQL::Client.new(endpoint_url)
    end

    ##
    # Returns the casted value
    #
    # @param [Object#value] obj
    # @return [String,nil]
    def safe_value(obj)
      Queryable.safe_value(obj)
    end

    ##
    # Cast the value to its datatype
    #
    # @param [Object] value
    # @param [Class] datatype
    # @return [String,nil]
    def cast(value, datatype)
      Queryable.cast(value, datatype)
    end

    private

    # @return [String]
    def endpoint_url
      ENV['TOGOID_ENDPOINT_URL'] || 'http://localhost:8890/sparql'
    end
  end

  ##
  # Returns the casted value
  #
  # @param [Object#value] obj
  # @return [String,nil]
  def safe_value(obj)
    return nil unless obj

    return obj unless obj.respond_to?(:value)

    return obj.value unless obj.respond_to?(:datatype)

    cast(obj.value, obj.datatype)
  end

  ##
  # Cast the value to its datatype
  #
  # @param [Object] value
  # @param [Class] datatype
  # @return [String,nil]
  def cast(value, datatype)
    case datatype
    when RDF::Literal::Boolean
      value.match?(/true/)
    when RDF::Literal::Integer
      value.to_i
    when RDF::Literal::Double, RDF::Literal::Decimal
      value.to_f
    when RDF::Literal::Time
      Time.parse(value)
    when RDF::Literal::Date
      Date.parse(value)
    when RDF::Literal::DateTime
      DateTime.parse(value)
    else
      value
    end
  end

  module Logger
    def query(query, options = {})
      ret = nil

      time = Benchmark.realtime do
        ret = super(query, options)
      end

      Rails.logger.info("SPARQL (#{format('%.1f', time * 1000)}ms) #{query}")

      ret
    end
  end

  ::SPARQL::Client.prepend Queryable::Logger
end
