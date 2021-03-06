# frozen_string_literal: true

# @api public
# @since 0.7.0
class SmartCore::Container
  require_relative 'container/errors'
  require_relative 'container/arbitrary_lock'
  require_relative 'container/key_guard'
  require_relative 'container/entities'
  require_relative 'container/definition_dsl'
  require_relative 'container/dependency_compatability'
  require_relative 'container/registry'
  require_relative 'container/registry_builder'
  require_relative 'container/dependency_resolver'
  require_relative 'container/mixin'

  # @since 0.7.0
  include DefinitionDSL

  # @return [SmartCore::Container::Registry]
  #
  # @api private
  # @since 0.7.0
  attr_reader :registry

  # @return [void]
  #
  # @api public
  # @since 0.7.0
  def initialize
    build_registry!
    @access_lock = ArbitraryLock.new
  end

  # @param dependency_name [String, Symbol]
  # @param dependency_definition [Block]
  # @return [void]
  #
  # @api public
  # @sicne 0.7.0
  def register(dependency_name, &dependency_definition)
    thread_safe { registry.register_dependency(dependency_name, &dependency_definition) }
  end

  # @param namespace_name [String, Symbol]
  # @param dependencies_definition [Block]
  # @return [void]
  #
  # @api public
  # @since 0.7.0
  def namespace(namespace_name, &dependencies_definition)
    thread_safe { registry.register_namespace(namespace_name, &dependencies_definition) }
  end

  # @param dependency_path [String, Symbol]
  # @return [Any]
  #
  # @api public
  # @since 0.7.0
  # @version 0.8.0
  def resolve(dependency_path)
    thread_safe { DependencyResolver.resolve(self, dependency_path) }
  end
  alias_method :[], :resolve

  # @param dependency_path [String, Symbol]
  # @return [Any]
  #
  # @api public
  # @since 0.8.0
  def fetch(dependency_path)
    thread_safe { DependencyResolver.fetch(self, dependency_path) }
  end

  # @return [void]
  #
  # @api public
  # @since 0.7.0
  def freeze!
    thread_safe { registry.freeze! }
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.7.0
  def frozen?
    thread_safe { registry.frozen? }
  end

  # @return [void]
  #
  # @api public
  # @since 0.7.0
  def reload!
    thread_safe { build_registry! }
  end

  # @option resolve_dependencies [Boolean]
  # @return [Hash<String|Symbol,SmartCore::Container::Entities::Base|Any>]
  #
  # @api public
  # @since 0.7.0
  def hash_tree(resolve_dependencies: false)
    thread_safe { registry.hash_tree(resolve_dependencies: resolve_dependencies) }
  end
  alias_method :to_h, :hash_tree
  alias_method :to_hash, :hash_tree

  private

  # @return [void]
  #
  # @api private
  # @since 0.7.0
  def build_registry!
    @registry = RegistryBuilder.build(self)
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.7.0
  def thread_safe(&block)
    @access_lock.thread_safe(&block)
  end
end
