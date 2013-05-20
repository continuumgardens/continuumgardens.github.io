
module Jekyll
  class Portfolio
    def self.submenu(subdirs)
      submenu = '<div id="wrapper-left"><div id="submenu"><ul>'
      subdirs.each do |entry|
        submenu << "<li><a href=\"#{entry}/index.html\">#{entry.gsub('_', ' ').capitalize}</a></li>"
      end
      submenu << '</ul></div>'
    end
  end

  class PortfolioMainPage < Page
    def initialize(site, base, dir, pages)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.data = {}
      self.data['title'] = "Portfolio"
      self.data['layout'] = "default"

      content = '<ul>'
      pages.sort.each do |entry|
        content << "<li><a href=\"#{entry}\"><img src=\"#{entry}/main-thumb.jpg\" />#{entry.gsub('_', ' ').capitalize}</a></li> "
      end
      content << "</ul>"
      self.content = content
      self.submenu = Portfolio::submenu(pages)
    end

  end

  class PortfolioPage < Page
    def initialize(site, base, dir, layout, pages, section)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.data = {}
      self.data['title'] = section.capitalize
      self.data['layout'] = "portfolio"

      self.submenu = Portfolio::submenu(pages)

      excludes = [".", "..", "main.jpg"]
      imgs = Dir.entries(dir).sort.select do |entry|
        (!File.directory?(File.join(dir,entry)) && !excludes.include?(entry))
      end

      content = '<li class="active">'
      content << '<img src="main.jpg" title="" alt="" /></li>'
      imgs.each do |img|
        content << "<li><img src=\"#{img}\" title=\"\" alt=\"\" /></li>"
      end
      self.content = content
    end
  end

  class PortfolioPageGenerator < Generator
    safe true

    def generate(site)
      # Check the layouts for portfolio and default layouts
      # pick the first that exists
      layout = nil
      ['portfolio', 'default'].each do |key|
        layout = key
        break if site.layouts.key? key
      end

      dir = site.config['portfolio_dir'] || 'portfolio'

      excludes = [".", ".."]
      dirs = Dir.entries(dir).sort.select do |entry|
        (File.directory?(File.join(dir,entry)) && !excludes.include?(entry))
      end

      portfolio_pages = []
      dirs.each do |section|
        srcdir = File.join(dir,section)

        site.pages << PortfolioPage.new(site, site.source,
                                        srcdir, layout,
                                        dirs, section)
      end
      site.pages << PortfolioMainPage.new(site, site.source,
                                          dir, dirs)
    end
  end
end
