module Matchers

  class HaveError

    def initialize(error, interpolations=nil, validate=false)
      @attribute = :base
      @error     = error
      @interpolations = interpolations || {}
      @validate = validate
    end

    # have_error(:x).on(:y)
    def on(attribute)
      @attribute = attribute
      self
    end

    def matches?(target)
      @target = target #for base_message error
      @target.valid? if @validate

      if @error.is_a?(Symbol)
        message = target.errors.send(:generate_message, @attribute, @error, @interpolations)
      else
        message = @error
      end

      # expect(object).to have_error (slightly irregular, would be on(:base) if not for this)
      if @attribute == :base && message.blank?
        target.errors.any?
      else
        array = (target.errors[@attribute] || [])
        # have_error.on(:something)
        if message.blank?
          array.any?
        # have_error(/something/).on(:something)
        elsif message.is_a?(Regexp)
          array.any?{|string| string =~ message }
        # have_error('something') # on base
        else
          array.include?(message)
        end
      end

    end

    def base_message
      s = "class to have error '#{@error || 'any'}' on #{@attribute}"
      s += " (got #{@target.errors.inspect})" if @target.errors.not_blank?
      s
    end

    def failure_message
      "expected #{base_message}"
    end

    def failure_message_when_negated
      "did not expect #{base_message}"
    end

    alias_method :negative_failure_message, :failure_message_when_negated

  end

  # @example
  #   expect(record).to have_error #=> any error on base
  # @example
  #   expect(record).to have_error(:blank).on(:name) #=> :symbol
  # @example
  #   expect(record).to have_error(/some message/)
  # @example
  #   expect(record).to have_error(:with_interpolations, :name => "bob")
  def have_error(error=nil, interpolations=nil)
    HaveError.new(error, interpolations)
  end

  # calls {valid?} first to ensure errors are present
  def have_error!(error=nil, interpolations=nil)
    HaveError.new(error, interpolations, true)
  end

end