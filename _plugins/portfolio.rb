
module Jekyll
  class Portfolio
    def self.submenu(base, subdirs)
      submenu = '<div id="wrapper-left"><div id="submenu"><ul>'
      subdirs.each do |entry|
        submenu << "<li><a href=\"/#{base}/#{entry}/index.html\">#{Portfolio::titlize(entry)}</a></li>"
      end
      submenu << '</ul></div>'
    end

    def self.titlize(str)
      nocap = ['and','of']
      str.gsub('_', ' ').gsub(/\b.+?\b/) do |s|
        nocap.include?(s) ? s : s.capitalize
      end
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
      self.data['submenu'] = Portfolio::submenu(dir, pages)

      content = '<ul>'
      pages.sort.each do |entry|
        content << "<li><a href=\"#{entry}\"><img src=\"#{entry}/main-thumb.jpg\" />#{Portfolio::titlize(entry)}</a></li> "
      end
      content << "</ul>"
      self.content = content
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
      self.data['title'] = Portfolio::titlize(section)
      self.data['layout'] = "portfolio"

      self.data['submenu'] = Portfolio::submenu(File.dirname(dir), pages)

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
