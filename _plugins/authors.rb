module Jekyll
  class AuthorsTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text   = text
      @tokens = tokens
    end

    def render(context)
      authors = context.environments.first['page']['author']
      authors = [authors] if authors.is_a?(String)

      "".tap do |output|
        authors.each do |author|
          output << Jekyll::IncludeTag.new('include', "#{author}.html", @tokens).render(context)
        end
      end
    end
  end
end

Liquid::Template.register_tag('authors', Jekyll::AuthorsTag)
