
module Jekyll
  class PortfolioMainPage < Page
    def initialize(site, base, dir, pages)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.data = {}
      self.data['title'] = "Portfolio"
      self.data['layout'] = "portfolio"

      self.data['submenu'] = CGSite::submenu("/"+dir, pages, "/index.html")
      content = ''
      pages.sort.each do |entry|
        content << "<div class=\"box\"><a href=\"#{entry}\"><img class=\"thumb\" src=\"#{entry}/main.jpg\" /><span class=\"caption simple-caption\"><p>#{CGSite::titlize(entry)}</p></span></a></div> "
      end
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
      self.data['title'] = CGSite::titlize(section)
      self.data['layout'] = "portfolio"

      self.data['submenu'] = CGSite::submenu("/"+File.dirname(dir),
                                             pages, "/index.html")

      excludes = [".", "..", "main.jpg"]
      imgs = Dir.entries(dir).sort.select do |entry|
        (!File.directory?(File.join(dir,entry)) && !excludes.include?(entry))
      end

      content = '<ul class="gallery"><li class="active">'
      content << '<img src="main.jpg" title="" alt="" /></li>'
      imgs.each do |img|
        content << "<li><img src=\"#{img}\" title=\"\" alt=\"\" /></li>"
      end
      content << '</ul>'
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
