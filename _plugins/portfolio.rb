
module Jekyll

  class PortfolioMainPage < Page
    def initialize(site, base, dir, sections)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, "_layouts"), "default.html")
      self.data['title'] = "Portfolio"
      self.data['content'] = "monkeysticks"
    end

  end

  class PortfolioPage < Page
    def initialize(site, base, dir, layout, section)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, "_layouts"), "#{layout}.html")
      self.data['title'] = section.capitalize
      self.data['portfolio'] = "true"
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

      portfolio_pages = []
      Dir.open(dir).each do |section|
        srcdir = File.join(dir,section)
        next unless (File.directory?(srcdir) &&
                     '.' != section && '..' != section)
        portfolio_pages << section
        site.pages << PortfolioPage.new(site, site.source,
                                        srcdir, layout, section)
      end
      site.pages << PortfolioMainPage.new(site, site.source,
                                          dir, portfolio_pages)
    end
  end
end
