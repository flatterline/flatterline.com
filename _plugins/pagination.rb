# Override Jekyll Pagination to output page/# paths.
module Jekyll
  class Pagination
    def paginate(site, page)
      if page.dir.end_with?(site.config['blog_dir'])
        all_posts = site.site_payload['site']['posts']
        pages = Pager.calculate_pages(all_posts, site.config['paginate'].to_i)
        (1..pages).each do |num_page|
          pager = Pager.new(site.config, num_page, all_posts, pages)
          if num_page > 1
            newpage = Page.new(site, site.source, page.dir, page.name)
            newpage.pager = pager
            newpage.dir = File.join(page.dir, "page/#{num_page}")
            site.pages << newpage
          else
            page.pager = pager
          end
        end
      end
    end
  end
end
