require 'date'

## Helper Methods
def usage
  puts "  ruby bin/new_post.rb \"My New Post Title\""
end

## Main Body

# Check for argument
if ARGV.empty?
  puts ''
  puts "Please provide the post title."
  usage
  puts ''
else
  title    = ARGV[0]
  filename = "#{Date.today.to_s}-#{title.downcase.gsub(/\s/, '-')}"
  filepath = File.expand_path("_posts/#{filename}.md")

  if File.exists?(filepath)
    puts ''
    puts "That file already exists - \"#{filepath}\""
    puts ''
  else
    template = File.read File.expand_path('_posts/_template.md')
    template.sub!(/^title:/, "title: \"#{title}\"")

    File.open(filepath, "w") { |file| file.puts template }
    `open #{filepath}`
  end
end
