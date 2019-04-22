class HGNC
  include Queryable

  class << self
    # @param [String, Integer] id HGNC Gene ID
    def find(id)
      id = id.to_s.sub(/(HGNC|hgnc):/, '').to_i

      s = RDF::URI("http://identifiers.org/hgnc/#{id}")
      query = client.select(:symbol, :name, :alias_names, :pubmed, :cross_references)
                .distinct
                .from(RDF::URI('http://togoid.dbcls.jp/graph/hgnc'))
                .where([s, RDF::RDFS.label, :symbol])
                .where([s, RDF::Vocab::DC.description, :name])
                .optional([s, RDF::Vocab::SKOS.altLabel, :alias_names])
                .optional([s, RDF::Vocab::DC.references, :pubmed])
                .optional([s, RDF::RDFS.seeAlso, :cross_references])

      result = query.result

      raise ResourceNotFound.new(nil, self, id) if result.count.zero?

      new(result) do |attr|
        attr.id = id
      end
    end

    # @param [String] symbol HGNC Gene symbol
    def find_by_symbol(symbol)
      query = client.select(:s, :name, :alias_names, :pubmed, :cross_references)
                .distinct
                .from(RDF::URI('http://togoid.dbcls.jp/graph/hgnc'))
                .where([:s, RDF::RDFS.label, symbol])
                .where([:s, RDF::Vocab::DC.description, :name])
                .optional([:s, RDF::Vocab::SKOS.altLabel, :alias_names])
                .optional([:s, RDF::Vocab::DC.references, :pubmed])
                .optional([:s, RDF::RDFS.seeAlso, :cross_references])

      result = query.result

      raise ResourceNotFound.new(nil, self, symbol) if result.count.zero?

      new(result) do |attr|
        attr.symbol = symbol
      end
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
      when Affymetrix
        from_affymetrix(obj)
      else
        raise(ArgumentError, "Unknown source: #{obj.class}")
      end
    end

    private

    def from_ncbi_gene(obj)
      find(identifier(RDF::RDFS.seeAlso, RDF::URI("http://identifiers.org/ncbigene/#{obj.id}")))
    end

    def from_refseq(obj)
      find(identifier(RDF::RDFS.seeAlso, RDF::URI("http://identifiers.org/refseq/#{obj.id}")))
    end

    def from_ensembl(obj)
      find(identifier(RDF::RDFS.seeAlso, RDF::URI("http://identifiers.org/ensembl/#{obj.id}")))
    end

    def from_affymetrix(obj)
      ncbi = identifier(RDF::URI('http://rdf.identifiers.org/ontology/link'), RDF::URI("http://identifiers.org/affy.probeset/#{obj.id}"))
      find(identifier(RDF::RDFS.seeAlso, RDF::URI("http://identifiers.org/ncbigene/#{ncbi}")))
    end

    def identifier(p, o)
      query = client.select(:id)
                .distinct
                .where([:id, p, o])

      result = query.result

      msg = "Not found any #{self} that associates #{o} with #{p}"
      raise(ResourceNotFound, msg) if result.count.zero?

      result.first.id.value.split('/').last
    end
  end

  attr_accessor :id
  attr_accessor :symbol
  attr_accessor :name
  attr_accessor :alias_names
  attr_accessor :pubmed
  attr_accessor :cross_references

  def initialize(attributes)
    attributes.each { |k, v| send("#{k}=", v) } if attributes.is_a?(Hash)

    if attributes.is_a?(RDF::Query::Solutions)
      bind = attributes.bindings
      @id = safe_value(Array(bind[:s]).uniq.first).to_i
      @symbol = safe_value(Array(bind[:symbol]).uniq.first)
      @name = safe_value(Array(bind[:name]).uniq.first)
      @alias_names = Array(bind[:alias_names]).uniq.map(&method(:safe_value))
      @pubmed = safe_value(Array(bind[:pubmed]).uniq.first)
      @cross_references = Array(bind[:cross_references]).uniq.map(&method(:safe_value))
    end

    yield self if block_given?
  end
end
