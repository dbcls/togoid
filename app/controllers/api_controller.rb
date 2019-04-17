class ApiController < ApplicationController
  # GET /convert
  def convert
    params = convert_params

    raise(TogoIDError, 'Missing parameter: id') unless (ids = params[:id].split(/[,\s]/))

    type = if (from = params[:from].presence)
             Identifier::TYPES[from]&.to_sym || raise(TogoIDError, "Unknown value for 'from': #{from}")
           else
             Identifier.detect(ids.first)
           end

    result = ids.map do |id|
      dest = type.klass == HGNC ? HGNC.find_by_symbol(id) : HGNC.convert(type.klass.find(id))
      {
        source: {
          id: id,
          type: type.key,
          label: type.label
        },
        destination: Array(dest.cross_references)
                       .select { |x| x.match?(Identifier::TYPES[:ncbi_gene].prefix) }
                       .map { |x| { id: RDF::URI(x).path.split('/').last, type: 'ncbi', label: 'NCBI Gene' } } # TODO hard coded
      }
    rescue StandardError => e
      Rails.logger.error([e.message, e.backtrace].flatten.join("\n"))
      {
        source: {
          id: id,
          type: type.key,
          label: type.label
        },
        error: e.message
      }
    end

    # TODO refactor
    if result.count { |x| x[:destination] } > 1
      result = ids.map do |id|
        dest = type.klass == HGNC ? HGNC.find_by_symbol(id) : HGNC.convert(type.klass.find(id))
        {
          source: {
            id: id,
            type: type.key,
            label: type.label
          },
          destination: [{ id: dest.symbol, type: 'hgnc', label: 'HGNC' }]
        }
      rescue StandardError => e
        Rails.logger.error([e.message, e.backtrace].flatten.join("\n"))
        {
          source: {
            id: id,
            type: type.key,
            label: type.label
          },
          error: e.message
        }
      end
    end

    respond_to do |format|
      format.json { render json: result }
    end
  rescue TogoIDError => e
    Rails.logger.error(e)
    respond_to do |format|
      format.json { render json: { error: e.message } }
    end
  end

  private

  def convert_params
    params.permit(:format, :id, :from, :to)
  end
end
