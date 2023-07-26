# frozen_string_literal: true

Decidim::SpamSignal::Scans::ScansRepository.instance.register(:forbidden_tlds, ::Decidim::SpamSignal::Scans::ForbiddenTldsScanCommand)
Decidim::SpamSignal::Scans::ScansRepository.instance.register(:allowed_tlds, ::Decidim::SpamSignal::Scans::AllowedTldsScanCommand)
Decidim::SpamSignal::Scans::ScansRepository.instance.register(:word, ::Decidim::SpamSignal::Scans::WordScanCommand)
Decidim::SpamSignal::Cops::CopsRepository.instance.register(:lock, ::Decidim::SpamSignal::Cops::LockCopCommand)
Decidim::SpamSignal::Cops::CopsRepository.instance.register(:sinalize, ::Decidim::SpamSignal::Cops::SinalizeCopCommand)
