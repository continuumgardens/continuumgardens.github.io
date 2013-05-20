module Jekyll
  class Quotation < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "<div id=\"quote\"><blockquote>&ldquo;" +
        randomquote(context.registers[:site]) +
        "&rdquo;</blockquote></div>"
    end

    def randomquote(site)
      ""
    end
  end
end

Liquid::Template.register_tag('quotation', Jekyll::Quotation)
