class HGNC
  include Queryable

  class << self
    def find(id)
      s = RDF::URI("http://identifiers.org/hgnc/#{id.sub(/(HGNC|hgnc):/, '')}")
      query = client.select(:symbol, :name, :alias_names, :pubmed, :cross_references)
                .distinct
                .from(RDF::URI('http://togoid.org/graph/hgnc'))
                .where([s, RDF::RDFS.label, :symbol])
                .where([s, RDF::Vocab::DC.description, :name])
                .optional([s, RDF::Vocab::SKOS.altLabel, :alias_names])
                .optional([s, RDF::Vocab::DC.references, :pubmed])
                .optional([s, RDF::RDFS.seeAlso, :cross_references])

      raise ResourceNotFound.new(nil, self, id) if query.result.count.zero?

      new do |attr|
        attr.id = id
        attr.symbol = safe_value(Array((bind = query.result.bindings)[:symbol]).uniq.first)
        attr.name = safe_value(Array(bind[:name]).uniq.first)
        attr.alias_names = Array(bind[:alias_names]).uniq.map(&method(:safe_value))
        attr.pubmed = safe_value(Array(bind[:pubmed]).uniq.first)
        attr.cross_references = Array(bind[:cross_references]).uniq.map(&method(:safe_value))
      end
    end

    def having(p, o)
      query = client.select(:s)
                .distinct
                .from(RDF::URI('http://togoid.org/graph/hgnc'))
                .where([:s, p, o])

      msg = "Not found any #{self} that associates #{o} with #{p}"
      raise(ResourceNotFound, msg) if query.result.count.zero?

      query.result
    end

    def convert(obj)
      case obj
      when HGNC
        obj
      when NCBIGene
        from_ncbi_gene(obj)
      when RefSeq
        from_refseq(obj)
      when Ensembl
        from_ensembl(obj)
      else
        raise(ArgumentError, "Unknown source: #{obj.class}")
      end
    end

    private

    def from_ncbi_gene(obj)
      having(RDF::RDFS.seeAlso, RDF::URI("http://identifiers.org/ncbigene/#{obj.id}")).map do |r|
        id = r.id.path.split('/').last
        find(id)
      end
    end

    def from_refseq(obj)
      having(RDF::RDFS.seeAlso, RDF::URI("http://identifiers.org/refseq/#{obj.id}")).map do |r|
        id = r.id.path.split('/').last
        find(id)
      end
    end

    def from_ensembl(obj)
      having(RDF::RDFS.seeAlso, RDF::URI("http://identifiers.org/ensembl/#{obj.id}")).map do |r|
        id = r.id.path.split('/').last
        find(id)
      end
    end
  end

  attr_accessor :id
  attr_accessor :symbol
  attr_accessor :name
  attr_accessor :alias_names
  attr_accessor :pubmed
  attr_accessor :cross_references

  def initialize(**attributes)
    attributes.each { |k, v| send("#{k}=", v) }

    yield self if block_given?
  end
end
