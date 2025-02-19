# frozen_string_literal: true
#
# bitclust/htmlutils.rb
#
# Copyright (C) 2006-2008 Minero Aoki
#
# This program is free software.
# You can distribute/modify this program under the Ruby License.
#

require 'bitclust/nameutils'

module BitClust

  # Utility functions for HTML tag generation
  module HTMLUtils

    include NameUtils

    private

    # make method anchor from MethodEntry
    def link_to_method(m, specp = false)
      label = specp ? m.label : m.short_label
      a_href(@urlmapper.method_url(methodid2specstring(m.id)), label)
    end

    def library_link(name, label = nil, frag = nil)
      a_href(@urlmapper.library_url(name) + fragment(frag), label || name)
    end

    def class_link(name, label = nil, frag = nil)
      a_href(@urlmapper.class_url(name) + fragment(frag), label || name)
    end

    def method_link(spec, label = nil, frag = nil)
      a_href(method_url(spec, frag), label || spec)
    end

    def method_url(spec, frag = nil)
      @urlmapper.method_url(spec) + fragment(frag)
    end

    def function_link(name, label = nil, frag = nil)
      a_href(@urlmapper.function_url(name) + fragment(frag), label || name)
    end

    def document_link(name, label = nil, frag = nil)
      a_href(@urlmapper.document_url(name) + fragment(frag),
             label || @option[:database].get_doc(name).title)
    end

    def fragment(str)
      str ? '#' + str : ''
    end

    def a_href(url, label)
      %Q(<a href="#{escape_html(url)}">#{escape_html(label)}</a>)
    end

    def a_href_ext(url, label, version=nil)
      url2 = if url.match?(%r!^/!) # modify local link to rurema Web
        "https://docs.ruby-lang.org/ja/#{version}#{url.gsub(/-([a-z])/){ $1.upcase}}"
      else
        url
      end
      %Q(<a href="#{escape_html(url2)}" target="_blank">#{escape_html(label)}</a>)
    end

    ESC = {
      '&' => '&amp;',
      '"' => '&quot;',
      '<' => '&lt;',
      '>' => '&gt;'
    }

    def escape_html(str)
      table = ESC   # optimize
      str.gsub(/[&"<>]/) {|s| table[s] }
    end

    ESCrev = ESC.invert

    def unescape_html(str)
      table = ESCrev   # optimize
      str.gsub(/&\w+;/) {|s| table[s] }
    end

  end

end
