# frozen_string_literal: true

class UbyInterpreter
  class Environment
    def initialize
      @env = [{}]
    end

    def [](key)
      all[key]
    end

    def []=(key, value)
      @env.last[key] = value
    end

    def all
      @env.inject(&:merge)
    end

    def scope
      @env.push({})
      yield
    ensure
      @env.pop
    end
  end
end
