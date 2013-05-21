module Jekyll
  class Testimonials < Liquid::Tag

    @@testimonials = nil
    @@randomtestimonials = nil

    def self.testimonials
      @@testimonials
    end

    def self.init_testimonials(site)
      @@testimonials = []
      @@randomtestimonials = []
      tdir = File.join(site.config["source"], "_testimonials")
      files = Dir::entries(tdir).select do |entry|
        (!File.directory?(File.join(tdir,entry)) && !entry.end_with?("~"))
      end

      files.each do |fname|
        File.open(File.join(tdir, fname)) do |file|
          content = file.read.chomp
          @@testimonials << [File.basename(fname, ".txt"), content]
          @@randomtestimonials << content
        end
      end
    end

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      site = context.registers[:site]
      init_testimonials(site) unless @@testimonials
      "<div id=\"quote\"><blockquote>&ldquo;" +
        randomquote(site) +
        "&rdquo;</blockquote></div>"
    end

    def randomquote(site)
      if @@randomtestimonials
        if @@randomtestimonials.size == 0
          refill_quotes
        end
        idx = rand(@@randomtestimonials.size)
        quote = @@randomtestimonials[idx]
        @@randomtestimonials.delete_at(idx)
        quote
      end
    end

    def refill_quotes
      @@testimonials.each do |pair|
        @@randomtestimonials << pair[1]
      end
    end

  end

  class TestimonialPage < Page
    def initialize(site, base, dir, testimonials)
      @site = site
      @base = base
      @dir = dir
      @name = 'testimonials.html'
      self.process(@name)

      self.data = {'title' => 'Client Testimonials',
                   'layout' => 'default'}

      content = ""
      testimonials.each do |entry|
        content << "<p>&ldquo;#{entry[1]}.&rdquo; &ndash; #{entry[0]}</p>"
      end
      self.content = content
    end
  end

  class TestimonialGenerator < Generator
    safe true

    def generate(site)
      Testimonials.init_testimonials(site) unless Testimonials.testimonials
      site.pages << TestimonialPage.new(site, site.source,
                                        "about",Testimonials.testimonials)
    end
  end

end

Liquid::Template.register_tag('testimonial', Jekyll::Testimonials)
