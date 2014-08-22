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

      # should_not have_error (slightly irregular, would be on(:base) if not for this)
      if @attribute == :base && message.blank?
        target.errors.any?
      else
        a = (target.errors[@attribute] || [])
        # have_error.on(:something)
        if message.blank?
          a.any?
        # have_error(/something/).on(:something)
        elsif message.is_a?(Regexp)
          a.any?{|r| r =~ message }
        # have_error('something') # on base
        else
          a.include?(message)
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

    def negative_failure_message
      "did not expect #{base_message}"
    end

  end

  def have_error(error=nil, interpolations=nil)
    HaveError.new(error, interpolations)
  end

  def have_error!(error=nil, interpolations=nil)
    HaveError.new(error, interpolations, true)
  end

end