class RefSeq
  include Queryable

  class << self
    def find(id)
      query = client.select
                 .from(RDF::URI('http://togoid.dbcls.jp/graph/hgnc'))
                 .where([RDF::URI("http://identifiers.org/refseq/#{id}"), :p, :o])

      raise ResourceNotFound.new(nil, self, id) if query.result.count.zero?

      new do |attr|
        attr.id = id
      end
    end
  end

  attr_accessor :id

  def initialize(**attributes)
    attributes.each { |k, v| send("#{k}=", v) }

    yield self if block_given?
  end

  def convert
    HGNC.convert(self)
  end
end
