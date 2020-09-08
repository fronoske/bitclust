#
# bitclust/docentry.rb
#
# Copyright (c) 2006-2008 Minero Aoki
#
# This program is free software.
# You can distribute/modify this program under the Ruby License.
#

require 'bitclust/entry'
require 'bitclust/exception'

module BitClust

  # Entry for general documents (doc/**/*.rd, etc.)
  class DocEntry < Entry

    def self.type_id
      :doc
    end

    def initialize(db, id)
      super db
      @id = id
      init_properties
    end

    attr_reader :id

    def ==(other)
      return false if self.class != other.class
      @id == other.id
    end

    alias eql? ==

    def hash
      @id.hash
    end

    def <=>(other)
      @id.casecmp(other.id)
    end

    def name
      libid2name(@id)
    end

    alias label name

    def labels
      [label()]
    end

    def name?(n)
      name() == n
    end

    persistent_properties {
      property :title,           'String'
      property :source,          'String'
      property :source_location, 'Location'
    }

    def inspect
      "#<doc #{@id}>"
    end

    def classes
      @db.classes
    end

    def error_classes
      classes.select{|c| c.error_class? }
    end

    def methods
      @db.methods
    end

    def libraries
      @db.libraries
    end

    def description
      source.split(/\n\n/, 2)[0].strip
    end
  end
end
