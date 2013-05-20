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

      submenutext = ""
      if (subpath != "/.")

        # Filter pages by whether they're in the same subdirectory
        pages = site.pages.select do |item|
          (item.dir == subpath)
        end
        # Need to pull out the index.html page first
        index = nil
        submenu = []
        pages.each do |page|
          # For each page, pull out it's title, and use it in the submenu
          pair = [page.name, page.data['title']]
          if page.name == "index.html"
            index = pair
          else
            submenu << pair
          end
        end
        submenu.insert(0, index)
        submenutext = CGSite::submenu(subpath[1..-1], submenu)
      end
      return submenutext
    end
  end
end

Liquid::Template.register_tag('submenu', Jekyll::SubmenuTag)
