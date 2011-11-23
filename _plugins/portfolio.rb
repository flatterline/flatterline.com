require 'pp'

module Jekyll
  class PortfolioIndex < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir  = dir
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'portfolio.html')
      self.data['projects'] = self.get_projects(site)
    end

    def get_projects(site)
      {}.tap do |projects|
        Dir['_projects/*.yml'].each do |path|
          name   = File.basename(path, '.yml')
          config = YAML.load(File.read(File.join(@base, path)))
          projects[name] = config if config['published']
        end
      end
    end
  end

  class ProjectIndex < Page
    def initialize(site, base, dir, path)
      @site     = site
      @base     = base
      @dir      = dir
      @name     = "index.html"
      self.data = YAML.load(File.read(File.join(@base, path)))

      self.process(@name) if self.data['published']
    end
  end

  class Site
    # Loops through the list of project pages and processes each one.
    def write_portfolio
      if Dir.exists?('_projects')
        Dir.chdir('_projects')
        Dir["*.yml"].each do |path|
          name = File.basename(path, '.yml')
          self.write_project_index("_projects/#{path}", name)
        end

        Dir.chdir(self.source)
        self.write_portfolio_index
      end
    end

    def write_portfolio_index
      portfolio = PortfolioIndex.new(self, self.source, "portfolio")
      portfolio.render(self.layouts, site_payload)
      portfolio.write(self.dest)
      self.static_files << portfolio
    end

    def write_project_index(path, name)
      project = ProjectIndex.new(self, self.source, "portfolio/#{name}", path)

      if project.data['published']
        project.render(self.layouts, site_payload)
        project.write(self.dest)
        self.static_files << project
      end
    end
  end

  class GeneratePortfolio < Generator
    safe true
    priority :low

    def generate(site)
      site.write_portfolio
    rescue => e
      puts e.message
      pp e.backtrace
    end
  end
end
