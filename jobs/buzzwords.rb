buzzwords = ['Github', 'Heroku', 'Sliqr', 'Expresso',
  'Ruby', 'Rails', 'Coffeescript', 'Yoba', 'Coffee']
buzzword_counts = Hash.new({ value: 0 })

SCHEDULER.every '5m' do
  random_buzzword = buzzwords.sample
  buzzword_counts[random_buzzword] = {
    label: random_buzzword,
    value: (buzzword_counts[random_buzzword][:value] + 1) % 30
  }
  send_event('buzzwords', { items: buzzword_counts.values })
end

