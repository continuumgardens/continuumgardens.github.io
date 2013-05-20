module Jekyll
  class Quotation < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
    end
  end
end

Liquid::Template.register_tag('quotation', Jekyll::Quotation)
