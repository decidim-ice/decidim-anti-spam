
now_tag = "\n[#{DateTime.now.strftime("%d/%m/%Y %H:%M")}]"
Decidim::User.where.not(blocked_at: nil).each do |suspicious_user| 
  admin_reporter = CopBot.get(suspicious_user.organization)
  suspicious_comments = Decidim::Comments::Comment.where(author: suspicious_user)
  suspicious_comments.each do |spam|
    moderation = Decidim::Moderation.find_or_create_by!(
      reportable: spam,
      participatory_space: spam.participatory_space
    )
    is_new = moderation.report_count == 0
    moderation.update(reported_content: spam.body[admin_reporter.locale]) if !moderation.reported_content && spam.body[admin_reporter.locale]
    report = Decidim::Report.find_or_create_by!(
      moderation: moderation.reload,
      user: admin_reporter) do |report|
        report.locale = admin_reporter.locale
        report.reason = "spam"
        report.details = "#{now_tag}cascade: #{spam}"
    end
    report.update(details: "#{report.details}#{now_tag}cascade: #{spam}")unless is_new
    moderation.update!(report_count: moderation.report_count + 1, hidden_at: Time.current)

end