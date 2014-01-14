require 'date'

require 'rugged'

data = File.read('./source.txt').split("\n")
dist = data[0].size.times.map {|i| data.map {|n| n[i] } }.flatten

date = Date.today - 366
date += 1 until date.wday.zero?

Dir.chdir('./dist') do
  repo = Rugged::Repository.init_at('.')

  dist.each do |char|
    date += 1

    next if char == ' '

    index = Rugged::Index.new

    options = {}
    options[:author]     = { email: "tricknotes.rs@gmail.com", name: 'Ryunosuke SATO', time: date.to_time }
    options[:committer]  = { email: "tricknotes.rs@gmail.com", name: 'Ryunpsuke SATO', time: date.to_time }
    options[:message]    = 'We love Ember.js :heart:'
    options[:update_ref] = 'HEAD'

    70.times do
      options[:parents]    = repo.empty? ? [] : [ repo.head.target ].compact
      options[:tree] = index.write_tree(repo)

      Rugged::Commit.create(repo, options)
    end
  end
end
