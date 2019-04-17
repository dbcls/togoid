class Identifier
  IdentifierType = Struct.new(:klass, :key, :label, :prefix, :pattern)

  TYPES = {
    ncbi_gene: IdentifierType.new(NCBIGene, :ncbi, 'NCBI Gene', 'http://identifiers.org/ncbigene/', /^\d+$/),
    refseq: IdentifierType.new(RefSeq, :refseq, 'RefSeq', 'http://identifiers.org/refseq/', /^(NC|NG|NM|NR|NT|XM|XR|YP)_\d+$/),
    ensembl: IdentifierType.new(Ensembl, :ensg, 'Ensembl Gene', 'http://identifiers.org/ensembl/', /^ENSG\d{11}$/),
    affymetrix: IdentifierType.new(Affymetrix, :affymetrix, 'Affymetrix', 'http://identifiers.org/', /\d{4,}((_[asx])?_at)?/),
    hgnc: IdentifierType.new(HGNC, :hgnc, 'HGNC', 'http://identifiers.org/hgnc/', /^((HGNC|hgnc):)?\d{1,5}$/)
  }.freeze

  class << self
    ##
    # Determine the type for given identifier
    #
    # @param [String] id
    # @return [IdentifierType]
    def detect(id)
      %i[ncbi_gene refseq ensembl affymetrix].each do |key|
        return TYPES[key] if id.match?(TYPES[key].pattern)
      end

      TYPES[:hgnc]
    end
  end
end
