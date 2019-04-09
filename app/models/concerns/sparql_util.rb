module SPARQLUtil
  ONTOLOGY = {
    uniprot: '<http://togogenome.org/graph/uniprot>',
    taxonomy: '<http://togogenome.org/graph/taxonomy>',
    go: '<http://togogenome.org/graph/go>',
    mpo: '<http://togogenome.org/graph/mpo>',
    meo: '<http://togogenome.org/graph/meo>',
    gold: '<http://togogenome.org/graph/gold>',
    tgup: '<http://togogenome.org/graph/tgup>',
    tgtax: '<http://togogenome.org/graph/tgtax>',
    meo_descendants: '<http://togogenome.org/graph/meo_descendants>',
    mpo_descendants: '<http://togogenome.org/graph/mpo_descendants>',
    goup: '<http://togogenome.org/graph/goup>',
    refseq: '<http://togogenome.org/graph/refseq>',
    stats: '<http://togogenome.org/graph/stats>',
    edgestore: '<http://togogenome.org/graph/edgestore>',
    so: '<http://togogenome.org/graph/so>',
    gotax: '<http://togogenome.org/graph/gotax>'
  }.freeze

  PREFIX = {
    up: 'PREFIX up: <http://purl.uniprot.org/core/>',
    mccv: 'PREFIX mccv: <http://purl.jp/bio/01/mccv#>',
    meo: 'PREFIX meo: <http://purl.jp/bio/11/meo/>',
    mpo: 'PREFIX mpo: <http://purl.jp/bio/01/mpo#>',
    insdc: 'PREFIX insdc: <http://ddbj.nig.ac.jp/ontologies/nucleotide/>',
    stats: 'PREFIX stats:<http://togogenome.org/stats/>',
    faldo: 'PREFIX faldo: <http://biohackathon.org/resource/faldo#>',
    obo: 'PREFIX obo: <http://purl.obolibrary.org/obo/>',
    refseq: 'PREFIX refseq: <http://identifiers.org/refseq/>'
  }.freeze
end
