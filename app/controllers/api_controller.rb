class ApiController < ApplicationController
  # GET /convert
  def convert
    params = convert_params

    raise(TogoIDError, 'Missing parameter: id') unless (ids = params[:id].split(/[,\s]/))

    type = if (from = params[:from].presence&.to_sym)
             Identifier::TYPES[from] || raise(TogoIDError, "Unknown value for 'from': #{from}")
           else
             Identifier.detect(ids.first)
           end

    result = ids.map do |id|
      dest = HGNC.convert(type.klass.find(id))
      {
        source: {
          id: id,
          type: type.key,
          label: type.label
        },
        destination: Array(dest.cross_references)
                       .select { |x| x.match?(Identifier::TYPES[:ncbi_gene].prefix) }
                       .map { |x| { id: RDF::URI(x).path.split('/').last, type: 'ncbi_gene', label: 'NCBI Gene' } } # TODO hard coded
      }
    rescue StandardError => e
      {
        source: {
          id: id,
          type: type.key,
          label: type.label
        },
        error: e.message
      }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  rescue TogoIDError => e
    respond_to do |format|
      format.json { render json: { error: e.message } }
    end
  end

  private

  def convert_params
    params.permit(:format, :id, :from, :to)
  end
end
