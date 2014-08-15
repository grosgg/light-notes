job_type :padrino_rake, "cd :path && RACK_ENV=:environment bundle exec rake :task --silent :output"

every 10.minutes do
  padrino_rake "evernote:sync"
end
