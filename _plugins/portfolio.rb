
module Jekyll

  class PortfolioPage < Page
    def initialize(site, base, dir, layout, section)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, "_layouts"), "#{layout}.html")
      self.data['title'] = section.capitalize
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

      Dir.open(dir).each do |section|
        srcdir = File.join(dir,section)
        next unless (File.directory?(srcdir) &&
                     '.' != section && '..' != section)
        site.pages << PortfolioPage.new(site, site.source,
                                        srcdir, layout, section)
      end
    end
  end
end
