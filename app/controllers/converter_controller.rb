class ConverterController < ApplicationController
  # GET /converter
  def index
    @mode = 'convert'
    @current = ApplicationHelper::SearchMethods::ID_CONVERTER
  end

  # GET /resolver
  def resolver
    @mode = 'resolver'
    @current = ApplicationHelper::SearchMethods::ID_RESOLVER
    render 'converter/index'
  end

  # GET /converter/convert
  def convert
    @databases   = convert_params[:databases]
    @identifiers = convert_params[:identifiers]
    @hits_count  = Converter.count(@identifiers, @databases)

    respond_to do |format|
      format.js do
        @display_count = [@hits_count, 100].min
        @db_links      = Converter.convert(@identifiers, @databases)
      end

      format.csv do
        @database_labels = @databases.map { |db| Database.find(db)['label'] }
        @filename        = 'identifiers.csv'
        @streaming       = true
      end
    end
  end

  # GET /converter/teach
  def teach
    @databases     = teach_params[:databases]
    @db_links      = Converter.sample(@databases)
    @identifiers   = @db_links.map { |item| item[:node0].split('/').last }
    @hits_count    = Converter.count(@identifiers, @databases)
    @display_count = @db_links.count
  end

  private

  def convert_params
    @convert_params ||= params.permit(databases: [], identifiers: [])
  end

  def teach_params
    @teach_params ||= params.permit(databases: [])
  end
end
