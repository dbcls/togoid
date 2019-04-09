require 'sparql_util'

class Converter
  class << self
    def query(sparql)
      endpoint = ENV['TOGOGENOME_ENDPOINT'] || 'http://localhost:8890/sparql'

      Rails.logger.debug('SPARQL ' + sparql.tr("\n", ' '))

      result = Rails.cache.fetch Digest::MD5.hexdigest(sparql), expires_in: 1.month do
        client = SPARQL::Client.new(endpoint)
        client.query(sparql)
      end

      Rails.logger.debug("Result: #{result.count}")

      return [] if result.bindings.empty?

      result.map { |x| x.to_h.transform_values(&:value) }
    end

    def count(identifiers, db_names)
      sparql = <<-SPARQL.strip_heredoc
        DEFINE sql:select-option "order"
        SELECT COUNT (?node0) AS ?hits_count
        WHERE {
          #{build_convert_sparql(identifiers, db_names)}
        }
      SPARQL

      query(sparql).first[:hits_count].to_i
    end

    def convert(identifiers, db_names, limit=100, offset=0)
      sparql = <<-SPARQL.strip_heredoc
        DEFINE sql:select-option "order"
        #{build_convert_sparql(identifiers, db_names)}
        LIMIT #{limit}
        OFFSET #{offset}
      SPARQL

      query(sparql)
    end

    def sample(db_names)
      sparql = <<-SPARQL.strip_heredoc
        DEFINE sql:select-option "order"
        SELECT DISTINCT ?node0
        #{make_sample_where_clause(db_names)}
        LIMIT 2
      SPARQL

      identifiers = query(sparql).map { |h| h[:node0].split('/').last }
      convert(identifiers, db_names, 100, 0)
    end

    private

    def build_convert_sparql(identifiers, db_names)
      <<-SPARQL.strip_heredoc
        SELECT DISTINCT #{select_target(db_names)}
        #{make_convert_where_clause(identifiers, db_names)}
      SPARQL
    end

    def select_target(db_names)
      db_names.count.times.map {|i| "?node#{i}" }.join(' ')
    end

    def mapping(db_names, start_index = 0)
      db_names.map.with_index(start_index) { |db_name, i|
        <<-EOS
          ?node#{i} rdfs:seeAlso ?node#{i.succ} .
          ?node#{i.succ} rdf:type <http://identifiers.org/#{db_name}> .
        EOS
      }.join
    end

    def make_graph(db_names)
      g = [make_tgup_graph(db_names), make_edgestore_graph(db_names)]
      (db_names.first == 'togogenome' ? g : g.reverse).join
    end

    def make_sample_where_clause(db_names)
      <<-EOS
        WHERE {
          #{make_graph(db_names)}
        }
      EOS
    end

    def make_convert_where_clause(identifiers, db_names)
      <<-EOS
        WHERE {
          VALUES ?node0 { #{make_values(db_names.first, identifiers)} }
          #{make_graph(db_names)}
        }
      EOS
    end

    def make_values(input_database, identifiers)
      if input_database == 'togogenome'
        identifiers.map { |identifier| "<http://togogenome.org/gene/#{identifier}>" }
      else
        identifiers.map { |identifier| "<http://identifiers.org/#{input_database}/#{identifier}>" }
      end.join(' ')
    end

    def make_edgestore_graph(db_names)
      input_database, *convert_databases = db_names

      if input_database == 'togogenome'
        <<-EOS
          GRAPH #{SPARQLUtil::ONTOLOGY[:edgestore]} {
            ?node1 rdf:type <http://identifiers.org/uniprot> .
            #{mapping(convert_databases.drop(1), 1)}
          }
        EOS
      else
        convert_databases.pop if convert_databases.last == 'togogenome'
        <<-EOS
          GRAPH #{SPARQLUtil::ONTOLOGY[:edgestore]} {
            ?node0 rdf:type <http://identifiers.org/#{input_database}> .
            #{mapping(convert_databases)}
          }
        EOS
      end
    end

    def make_tgup_graph(db_names)
      return '' unless db_names.include?('togogenome')
      <<-EOS
        GRAPH #{SPARQLUtil::ONTOLOGY[:tgup]} {
          ?#{"node#{db_names.index('togogenome')}"} rdfs:seeAlso ?#{"node#{db_names.index('uniprot')}"} .
        }
      EOS
    end
  end
end
