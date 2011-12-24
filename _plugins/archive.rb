# From https://github.com/josegonzalez/josediazgonzalez.com/blob/master/_plugins/archive.rb
module Jekyll

  class ArchiveIndex < Page
    def initialize(site, base, dir, type)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), type + '.html')
      self.data['collated_posts'] = self.collate(site)

      # Account for the path prefix of "/blog/"
      split_path = dir.split('/')
      split_path.shift
      split_path.shift

      year, month, day = split_path
      self.data['year'] = year.to_i
      month and self.data['month'] = month.to_i
      day and self.data['day'] = day.to_i

      self.data['title'] = "Blog Archive for #{[year.to_i, month, day].compact.join('-')}"
    end

    def collate(site)
      collated_posts = {}
      site.posts.reverse.each do |post|
        y, m, d = post.date.year, post.date.month, post.date.day
        
        collated_posts[ y ] = {} unless collated_posts.key? y
        collated_posts[ y ][ m ] = {} unless collated_posts[y].key? m
        collated_posts[ y ][ m ][ d ] = [] unless collated_posts[ y ][ m ].key? d
        collated_posts[ y ][ m ][ d ].push(post) unless collated_posts[ y ][ m ][ d ].include?(post)
      end
      return collated_posts
    end
    
  end

  class ArchiveGenerator < Generator
    safe true
    attr_accessor :collated_posts


    def generate(site)
      self.collated_posts = {}
      collate(site)

      self.collated_posts.keys.each do |y|
        write_archive_index(site, y.to_s, 'archive_yearly') if site.layouts.key? 'archive_yearly'
        self.collated_posts[ y ].keys.each do |m|
          write_archive_index(site, "%04d/%02d" % [ y.to_s, m.to_s ], 'archive_monthly') if site.layouts.key? 'archive_monthly'
          self.collated_posts[ y ][ m ].keys.each do |d|
            write_archive_index(site, "%04d/%02d/%02d" % [ y.to_s, m.to_s, d.to_s ], 'archive_daily') if site.layouts.key? 'archive_daily'
          end
        end
      end
    end

    def write_archive_index(site, dir, type)
      archive = ArchiveIndex.new(site, site.source, "/blog/#{dir}", type)
      archive.render(site.layouts, site.site_payload)
      archive.write(site.dest)

      site.pages << archive
      site.static_files << archive
    end

    def collate(site)
      site.posts.reverse.each do |post|
        y, m, d = post.date.year, post.date.month, post.date.day
        
        self.collated_posts[ y ] = {} unless self.collated_posts.key? y
        self.collated_posts[ y ][ m ] = {} unless self.collated_posts[y].key? m
        self.collated_posts[ y ][ m ][ d ] = [] unless self.collated_posts[ y ][ m ].key? d
        self.collated_posts[ y ][ m ][ d ].push(post) unless self.collated_posts[ y ][ m ][ d ].include?(post)
      end
    end
  end
end