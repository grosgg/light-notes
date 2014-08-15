namespace :evernote do
  desc "Sync all evernotes"
  task :sync => :environment do
    logger.info "Start evernote synchronization"
    Account.nin(evernote_token: [nil, '']).where(role: 'user').each do |account|
      logger.info "Sync notes for #{account.name}"
      sync_count = account.synchronize!
      logger.info "Successfully synced #{sync_count} notes!"
    end
    logger.info "Finish evernote synchronization"
  end
end