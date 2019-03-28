class Identifier
  IdentifierType = Struct.new(:klass, :key, :label, :prefix, :pattern)

  TYPES = {
    hgnc: IdentifierType.new(HGNC, :hgnc, 'HGNC', 'http://identifiers.org/hgnc/', /^((HGNC|hgnc):)?\d{1,5}$/),
    ncbi_gene: IdentifierType.new(NCBIGene, :ncbi, 'NCBI Gene', 'http://identifiers.org/ncbigene/', /^\d+$/),
    refseq: IdentifierType.new(RefSeq, :refseq, 'RefSeq', 'http://identifiers.org/refseq/', /^(NC|NG|NM|NR|NT|XM|XR|YP)_\d+$/),
    # affymetrix: IdentifierType.new(Affymetrix, :affymetrix, 'Affymetrix', 'http://identifiers.org/', //),
    ensembl: IdentifierType.new(Ensembl, :ensg, 'Ensembl Gene', 'http://identifiers.org/ensembl/', /^ENSG\d{11}$/)
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
