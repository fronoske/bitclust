# frozen_string_literal: true
#
# bitclust/functionreferenceparser.rb
#
# Copyright (c) 2006-2007 Minero Aoki
#
# This program is free software.
# You can distribute/modify this program under the Ruby License.
#

require 'bitclust/exception'

module BitClust

  # Parser for C API reference file (refm/capi/src/*)
  # Much simpler than Ruby API reference parser(RRDParser)
  # because C APIs does not have library, class, etc.
  class FunctionReferenceParser

    # Returns an array of FunctionEntry
    def FunctionReferenceParser.parse_file(path, params = {"version" => "1.9.0"})
      parser = new(FunctionDatabase.dummy(params))
      parser.parse_file(path, File.basename(path, ".rd"), params)
    end

    def initialize(db)
      @db = db
    end

    def parse_file(path, filename, properties)
      fopen(path, 'r:UTF-8') {|f|
        return parse(f, filename, properties)
      }
    end

    def parse(f, filename, params = {})
      @filename = filename
      @path = f.path
      s = Preprocessor.read(f, params)
      file_entries LineInput.for_string(s)
      @db.functions
    end

    private

    def file_entries(f)
      f.skip_blank_lines
      f.while_match(/\A---/) do |header|
        entry header.sub(/\A---/, '').strip, f.break(/\A---/)
        f.skip_blank_lines
      end
    end

    def entry(header, body)
      h = parse_header(header)
      @db.open_function(h.name) {|f|
        f.filename = @filename
        f.macro = h.macro
        f.private = h.private
        f.type = h.type
        f.name = h.name
        f.params = h.params
        f.source = body.join('')
        f.source_location = body[0]&.location&.tap {|loc| break Location.new(@path, loc.line - 1) }
      }
    end

    def parse_header(header)
      h = FunctionHeader.new
      m = header.match(/\A\s*(MACRO\s+)?(static\s+)?(.+?\W)(\w+)(\(.*\))?\s*\z/)
      raise ParseError, "syntax error: #{header.inspect}" unless m
      h.macro = m[1] ? true : false
      h.private = m[2] ? true : false
      h.type = m[3].strip
      h.name = m[4]
      h.params = m[5].strip if m[5]
      h
    end

  end

  # Represents C function signature
  # (Used internally in this file)
  FunctionHeader = Struct.new(:macro, :private, :type, :name, :params)

end
