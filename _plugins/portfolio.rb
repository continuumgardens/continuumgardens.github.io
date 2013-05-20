
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
end
