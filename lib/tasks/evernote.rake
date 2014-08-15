namespace :evernote do
  desc "Sync all evernotes"
  task :sync => :environment do
    logger.info "Start evernote synchronization"
    Account.nin(evernote_token: [nil, '']).where(role: 'user').each do |account|
      logger.info "Sync notes for #{account.name}"
      account.synchronize!
    end
    logger.info "Finish evernote synchronization"
  end
end