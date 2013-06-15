
module Jekyll
  class CGSite
    def self.submenu(base, entries, suffix="")
      submenu = '<div id="submenu"><ul>'
      entries.each do |entry|
        if (entry.is_a?(Array) && entry.size == 2)
          link = entry[0]+suffix
          text = entry[1]
        else
          link = entry+suffix
          text = CGSite::titlize(entry)
        end
        url = File.join(base,link)
        submenu << "<li><a href=\"#{url}\">#{text}</a></li>"
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