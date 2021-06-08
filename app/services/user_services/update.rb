class UserServices::Update
  def initialize(context)
    @context = Hashie::Mash.new context
    @user = User.find(@context["id"].to_i)

    @valid = nil
    @errors = []
  end

  def execute
    self.validate if @valid.nil?

    return @context if @valid

    update_user

    @context
  end

  def validate
    errors = []

    errors << "User params not present to update" if @context["user"].blank?

    @context[:errors] = errors
    return @valid = errors.present?
  end

  private

  def update_user
    @user.assign_attributes(@context["user"])
    if @user.save
      @context[:result] = @user
    else
      @context[:errors] = @user.errors.full_messages
      @valid = true
    end
  end
end
