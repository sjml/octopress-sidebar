# Octopress Sidebar

This plugin makes it easy to create a list of sites (organized into sections) for your Octopress sidebar. It's nothing you couldn't do with a bit of HTML or Markdown, but this handles sorting (either manually or automatically), and makes entering the sites much quicker. 

This plugin is a heavily modified version of Balaji Sivaraman's [Blogroll for Octopress](https://github.com/BalajiSi/octopress-blogroll) plugin. It removes all the fancy JavaScript sorting and polling of RSS feeds that the original plugin had, since I didn't have need for them. It shouldn't be *too* hard to add them back if you love them. 

## Installation

1. Put the `sidebar.rb` file in the `_plugins` directory of your Octopress site.

1. Copy `_includes/sidebar.html` into the `source/asides` or `source/custom/asides` directory of your Octopress blog.

1. Add `sidebar.html` into your sidebar configuration through `_config.yml`.

1. Create a `_sidebar` folder somewhere in your `source` directory and place all the site YAML files in there and enjoy an easy-to-use list of links.

## Technical details

Each file in the _sidebar directory must be a YAML file, named conforming to the scheme `1.my_section_name.yml`. The number before the period will be used to order the section, and the rest of the filename (minus the ".yml") will be titlecased to become the section's label. 

The files use the following syntax:

```yaml
---
name: Google
url: http://google.com
---
name: Yahoo!
url: http://www.yahoo.com
order: 1
---
name: DuckDuckGo
url: http://duckduckgo.com
```

Each site (separated by "---") needs a name and a URL. Sites will be ordered alphabetically by name unless given an "order" attribute, in which case that number will be used. Sites without an "order" attribute are assumed to have an ordering of 9999. 

If you're linking to a group of people, you can use this syntax instead:

```yaml
---
fname: Linus
lname: Torvalds
url: https://plus.google.com/+LinusTorvalds
---
fname: Bill
lname: Gates
url: http://www.thegatesnotes.com/
---
fname: Steve
lname: Jobs
url: http://www.apple.com/stevejobs/
```

If a record has an "fname" attribute, it will be appended to the front for display purposes, but the last name will be used for sorting. An "order" attribute will override last name sorting. 

## Licencing, bug reports, patches, etc

This plugin is licenced under the terms of the [GNU GPL version 3](http://www.gnu.org/licenses/gpl-3.0.html). If it works for you, great to know I've been of some help. If it doesn't, please feel free to enter an issue on this repo.
