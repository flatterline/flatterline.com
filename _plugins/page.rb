# Override Jekyll Page method to use dir attribute if set
module Jekyll
  class Page
    def dir
      @dir || (url[-1, 1] == '/' ? url : File.dirname(url))
    end
  end
end
