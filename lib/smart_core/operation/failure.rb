# frozen_string_literal: true

# @api public
# @since 0.2.0
class SmartCore::Operation::Failure < SmartCore::Operation::Result
  # @return [Array<Symbol|Any>]
  #
  # @api public
  # @since 0.2.0
  alias_method :errors, :__result_attributes__

  # @param errors [Array<Symbol|Any>]
  # @return [void]
  #
  # @api pubic
  # @since 0.2.0
  def initialize(*errors)
    super(*errors)
  end

  # @yield [nil]
  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def failure?
    true.tap { yield(self) if block_given? }
  end
end
