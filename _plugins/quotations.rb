module Jekyll
  class Quotation < Liquid::Tag

    @@quotelist = nil
    @@randomquotelist = nil
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      site = context.registers[:site]
      init_testimonials(site) unless @@quotelist
      "<div id=\"quote\"><blockquote>&ldquo;" +
        randomquote(site) +
        "&rdquo;</blockquote></div>"
    end

    def init_testimonials(site)
      @@quotelist = []
      @@randomquotelist = []
      tdir = File.join(site.config["source"], "_testimonials")
      files = Dir::entries(tdir).select do |entry|
        (!File.directory?(File.join(tdir,entry)) && !entry.end_with?("~"))
      end

      files.each do |fname|
        File.open(File.join(tdir, fname)) do |file|
          content = file.read.chomp
          @@quotelist << [fname, content]
          @@randomquotelist << content
        end
      end
    end

    def randomquote(site)
      ""
    end
  end
end

Liquid::Template.register_tag('quotation', Jekyll::Quotation)
