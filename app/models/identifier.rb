class Identifier
  IdentifierType = Struct.new(:klass, :key, :prefix, :pattern)

  TYPES = {
    hgnc: IdentifierType.new(HGNC, :hgnc, 'http://identifiers.org/hgnc/', /^((HGNC|hgnc):)?\d{1,5}$/),
    ncbi_gene: IdentifierType.new(NCBIGene, :ncbi, 'http://identifiers.org/ncbigene/', /^\d+$/),
    refseq: IdentifierType.new(RefSeq, :refseq, 'http://identifiers.org/refseq/', /^(NC|NG|NM|NR|NT|XM|XR|YP)_\d+$/),
    # affymetrix: IdentifierType.new(Affymetrix, :affymetrix, 'http://identifiers.org/', //),
    ensembl: IdentifierType.new(Ensembl, :ensg, 'http://identifiers.org/ensembl/', /^ENSG\d{11}$/)
  }.freeze

  class << self
    ##
    # Determine the type for given identifier
    #
    # @param [String] id
    # @return [IdentifierType]
    def detect(id)
      %i[refseq ensembl].each do |key|
        return TYPES[key] if id.match?(TYPES[key].pattern)
      end

      return TYPES[:hgnc] if (m = id.match(TYPES[:hgnc].pattern)) && m[1].present?

      raise(DetectionFailure, "Cannot determine identifier type: #{id}")
    end
  end
end
