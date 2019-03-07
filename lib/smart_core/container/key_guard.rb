# frozen_string_literal: true

# @api priavate
# @since 0.5.0
module SmartCore::Container::KeyGuard
  class << self
    # @param key [Symbol, String]
    # @return [void]
    #
    # @raise [SmartCore::Container::ArgumentError]
    #
    # @api private
    # @since 0.5.0
    def prevent_incomparabilities!(key)
      raise(
        SmartCore::Container::ArgumentError,
        'Namespace/Dependency name should be a symbol or a string'
      ) unless key.is_a?(String) || key.is_a?(Symbol)
    end
  end
end
