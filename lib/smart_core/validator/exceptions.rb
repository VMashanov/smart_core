# frozen_string_literal: true

class SmartCore::Validator
  # @api public
  # @since 0.1.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.1.0
  IncorrectErrorCodeError = Class.new(Error)

  # @api public
  # @since 0.1.0
  IncorrectAttributeNameError = Class.new(Error)
end
