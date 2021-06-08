class CabServices::Update
  def initialize(context)
    @context = Hashie::Mash.new context
    @cab = Cab.find(@context["id"].to_i)

    @valid = nil
    @errors = []
  end

  def execute
    self.validate if @valid.nil?

    return @context if @valid

    update_cab

    @context
  end

  def validate
    errors = []

    errors << "Cab params not present to update" if @context["cab"].blank?

    @context[:errors] = errors
    return @valid = errors.present?
  end

  private

  def update_cab
    @cab.assign_attributes(@context["cab"])
    if @cab.save
      @context[:result] = @cab
    else
      @context[:errors] = @cab.errors.full_messages
      @valid = true
    end
  end
end
