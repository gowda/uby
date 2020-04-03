# frozen_string_literal: true

require 'sexp_processor'
require 'ruby_parser'

class UbyInterpreter < SexpInterpreter
  require_relative 'uby_interpreter/environment'

  attr_accessor :parser, :env

  def initialize
    super
    self.parser = RubyParser.new
    self.env = Environment.new
  end

  def eval(src)
    process parse(src)
  end

  def parse(src)
    parser.process(src)
  end

  def process_lit(sexp)
    sexp.last
  end

  def process_call(sexp)
    _, recv, msg, *args = sexp

    recv = process recv
    args.map! { |sub| process sub }

    if recv
      recv.send(msg, *args)
    else
      decls, statements = env[msg]

      env.scope do
        decls.rest.zip(args).each do |name, value|
          env[name] = value
        end

        process_block s(:block, *statements)
      end
    end
  end

  def process_nil(_sexp)
    nil
  end

  def process_true(_sexp)
    true
  end

  def process_false(_sexp)
    false
  end

  def process_if(sexp)
    _, condition, texp, fexp = sexp

    if process(condition)
      process(texp)
    else
      process(fexp)
    end
  end

  def process_block(sexp)
    _, *statements = sexp

    ret = nil

    statements.each do |statement|
      ret = process statement
    end

    ret
  end

  def process_lasgn(sexp)
    _, name, expression = sexp

    env[name] = process expression
  end

  def process_lvar(sexp)
    _, name = sexp
    env[name]
  end

  def process_defn(sexp)
    _, name, args, *statements = sexp

    env[name] = [args, statements]

    nil
  end

  def process_while(sexp)
    _, condition, block = sexp
    process block while process(condition)
  end
end
