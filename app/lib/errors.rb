class TogoIDError < StandardError
end

class TypeNotFound < TogoIDError
end

class DetectionFailure < TogoIDError
end

class ResourceNotFound < TogoIDError
  attr_reader :model, :id

  def initialize(message = nil, model = nil, id = nil)
    @model = model
    @id = id

    message ||= "Not found #{id} in #{model}" if id && model

    super(message)
  end
end
