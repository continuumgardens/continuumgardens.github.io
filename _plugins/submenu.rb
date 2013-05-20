module Jekyll
  class SubmenuTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      site = context.registers[:site]
      base = site.config["source"]

      filename = context.environments[0]["page"]["path"]
      # Prepend a slash for ease of comparison with Page.dir
      subpath = "/"+File.dirname(filename)

      submenu = ""
      if (subpath != "/.")

        # Filter pages by whether they're in the same subdirectory
        pages = site.pages.select do |item|
          (item.dir == subpath)
        end
        p pages[0].data
        # Need to pull out the index.html page first
        pages.each do |page|
          # For each page, pull out it's title, and use it in the submenu
          subpath << "#{page.data['title']}"
        end
      end
      return submenu
    end
  end
end

Liquid::Template.register_tag('submenu', Jekyll::SubmenuTag)
