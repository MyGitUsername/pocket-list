require 'net/http'
require 'json'
require 'optparse'


class JsonResponseParser
  def self.get_title(resp)
    title = ""
    if not resp["given_title"].empty?
      title = resp["given_title"]
    elsif not resp["resolved_title"].empty?
      title = resp["resolved_title"]
    elsif resp["given_url"].empty?
      title = resp["given_url"]
    else 
      title = resp["resolved_url"]
    end
    title
  end
  
  def self.get_date(resp)
    Time.at(resp["time_added"].to_i).strftime("%F")
  end

  def self.get_link(resp)
    resp["given_url"].empty? ? resp["resolved_url"] : resp["given_url"]
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: pocket.rb --consumer-key CONSUMER-KEY --access-token ACCESS-TOKEN [-m --markdown]"

  opts.on("-t", "--access-token ACCESS-TOKEN", "The users Pocket access token.") do |t|
    options[:access_token] = t
  end
  opts.on("-k", "--consumer-key CONSUMER-KEY", "Your application's Consumer Key.") do |k|
    options[:consumer_key] = k
  end
  opts.on("-m", "--markdown", "Output the list in Github markdown syntax.") do
    options[:markdown] = true
  end
  opts.on("-h", "--help", "Prints this usage documentation.") do
    puts opts
    exit
  end

  ARGV << '-h' if ARGV.empty? || !ARGV.include?("--consumer-key") || !ARGV.include?("--access-token")
end.parse!


uri = URI('https://getpocket.com/v3/get')
res = Net::HTTP.post_form(uri, "consumer_key" => options[:consumer_key],
                          "access_token" => options[:access_token])
pocket_list = JSON.parse(res.body)["list"]
output = ""

pocket_list.each do |_, v|
  title = JsonResponseParser.get_title(v)
  date = JsonResponseParser.get_date(v)

  if options[:markdown]
    link = JsonResponseParser.get_link(v)
    output.concat("[#{title}](#{link}) (#{date})  \n")
  else
    output.concat("#{title} (#{date})\n")
  end
end

puts output
