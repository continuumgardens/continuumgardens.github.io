module Jekyll
  class Quotation < Liquid::Tag

    @@quotelist = nil
    @@randomquotelist = nil

    def self.testimonials
      @@quotelist
    end

    def self.init_testimonials(site)
      @@quotelist = []
      @@randomquotelist = []
      tdir = File.join(site.config["source"], "_testimonials")
      files = Dir::entries(tdir).select do |entry|
        (!File.directory?(File.join(tdir,entry)) && !entry.end_with?("~"))
      end

      files.each do |fname|
        File.open(File.join(tdir, fname)) do |file|
          content = file.read.chomp
          @@quotelist << [File.basename(fname, ".txt"), content]
          @@randomquotelist << content
        end
      end
      p @@quotelist
    end

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

    def randomquote(site)
      if @@randomquotelist
        if @@randomquotelist.size == 0
          refill_quotes
        end
        idx = rand(@@randomquotelist.size)
        quote = @@randomquotelist[idx]
        @@randomquotelist.delete_at(idx)
        quote
      end
    end

    def refill_quotes
      @@quotelist.each do |pair|
        @@randomquotelist << pair[1]
      end
    end

  end
end

Liquid::Template.register_tag('quotation', Jekyll::Quotation)
