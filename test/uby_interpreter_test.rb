# frozen_string_literal: true

require 'minitest/autorun'
require 'uby_interpreter'

class UbyInterpreterTest < Minitest::Test
  attr_accessor :interpreter

  def setup
    self.interpreter = UbyInterpreter.new
  end

  def assert_eval(exp, src, msg = nil)
    assert_equal exp, interpreter.eval(src), msg
  end

  def assert_eval_nil(src, msg = nil)
    assert_nil interpreter.eval(src), msg
  end

  def test_sanity
    assert_eval 3, '3', '3 is 3'
    assert_eval 7, '3 + 4', '"3+4" is 7'
  end

  def test_if
    assert_eval 42, 'if true then 42 else 24 end'
  end

  def test_if_falsey
    assert_eval 24, 'if nil then 42 else 24 end'
    assert_eval 24, 'if false then 42 else 24 end'
  end

  def test_lvar
    assert_eval 42, 'x = 42; x'
  end

  def test_defn
    assert_eval_nil <<-DEFINITION
      def double(n)
        2 * n
      end
    DEFINITION

    assert_eval 42, 'double(21)'
  end

  def define_fib
    assert_eval_nil <<-DEFINITION
      def fib(n)
        if n <= 2
          1
        else
          fib(n-2) + fib(n-1)
        end
      end
    DEFINITION
  end

  def test_fib
    define_fib

    assert_eval 8, 'fib(6)'
  end

  def test_while
    define_fib

    assert_eval 1 + 1 + 2 + 3 + 5 + 8 + 13 + 21 + 34 + 55, <<-CODE
      n = 1
      sum = 0
      while n <= 10
        sum += fib(n)
        n += 1
      end
      sum
    CODE
  end
end
