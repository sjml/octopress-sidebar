# Sidebar for Octopress
# Created By: Shane Liesegang (shane@techie.net)
# 
# Modified From Blogroll for Octorpress by 
#   Balaji Sivaraman (sivaraman.balaji@gmail.com)
# =========================================================
# 
# Description:
# ------------
# This plugin will read a list of YAML files containing details of 
#  your sidebar, and output a set of lists. 
# The YAML files itself must be placed in a _sidebar folder, which 
#  can be in any hierarchy inside your blog's source directory. 
# All the files inside the _sidebar folder will be parsed. Note that
#  they must be of the form 1.my_section.html. That is, an integer,
#  a dot, and an underscore-separated name. The integer will be used
#  to order the sections, and the rest of the filename (minus the 
#  ".yml") will be titlecased and become the section label. 
# 
# Syntax for YAML file:
# ---------------------
# ---
# name: Google
# url: http://google.com
# ---
# name: Yahoo!
# url: http://www.yahoo.com
# order: 1
# ---
# name: DuckDuckGo
# url: http://duckduckgo.com
# 
# The "---" separates each record. The "order" attribute is 
#  optional, but if present will be used for sorting. Any record 
#  without a specified ordering is treated as if its order is 9999. 
# If orders are equal, sites are sorted alphabetically by name.
# 
# Another file format is as such:
# ---
# fname: Linus
# lname: Torvalds
# url: https://plus.google.com/+LinusTorvalds
# ---
# fname: Bill
# lname: Gates
# url: http://www.thegatesnotes.com/
# ---
# fname: Steve
# lname: Jobs
# url: http://www.apple.com/stevejobs/
# 
# If a record has an "fname" attribute, it will be appended to 
#  the front for display purposes, but the last name will be
#  used for sorting. An "order" attribute will override last name 
#  sorting. 
# 
# Licence:
# --------
# Distributed under the [GNU General Public License].
# 
# [GPL]: http://www.gnu.org/licenses/gpl.html
#
module Jekyll
  
  class DynamicSidebar < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
    end

    def getSiteName(site)
      if site["fname"] != nil and site["lname"] != nil
        "#{site["fname"]} #{site["lname"]}"
      elsif site["name"] != nil
        "#{site["name"]}"
      elsif site["lname"] != nil
        "#{site["lname"]}"
      elsif site["url"] != nil
        "#{site["url"]}"
      else
        "NO NAME"
      end
    end

    def sortSites(site1, site2)
      if site1["order"] != nil or site2["order"] != nil
        if site1["order"] == nil
          site1["order"] = 9999
        end
        if site2["order"] == nil
          site2["order"] = 9999
        end
        site1["order"] <=> site2["order"]
      elsif site1["lname"] != nil and site2["lname"] != nil
        site1["lname"].downcase <=> site2["lname"].downcase
      else
        getSiteName(site1).downcase <=> getSiteName(site2).downcase
      end
    end

    def render(context)
      source = context.registers[:site].source
      sectionlist = getSectionList(source)
      html = ''

      sectionlist.each do |siteinfo|
        next if siteinfo.nil?
        html << "<section><h1>#{siteinfo[:title]}</h1><ul>"
        siteinfo[:sitelist].sort! { |site1,site2| sortSites(site1, site2) }
        siteinfo[:sitelist].each do |site|
          html << "<li><a href=\"#{site["url"]}\" target=\"_\">#{getSiteName(site)}</a></li>"
        end
        html << "</ul></section>"
      end
      html
    end

    def getSectionList(source)
      sectionlist = Array.new
      Dir["#{source}/**/_sidebar/**/*"].sort.each do |roll|
        sitelist = Array.new
        next unless File.file?(roll) and File.readable?(roll)
        File.open( roll ) do |roll_file|
          YAML.load_documents(roll_file) do |site|
            sitelist << site
          end
        end
        basename = File.basename(roll, '.yml')
        pieces = basename.split(".")
        if (pieces.length < 2)
          raise "No ordering given for sidebar #{basename}"
        end
        order = pieces[0].to_i
        title = pieces[1..-1].join(".")
        title.gsub!(/\s+|_/, " ")
        sectionlist[order] = {:title => title.titlecase, :sitelist => sitelist}
      end
      sectionlist
    end

  end
  
end

Liquid::Template.register_tag('dynamic_sidebar', Jekyll::DynamicSidebar)
