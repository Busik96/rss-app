Premailer::Rails.config.merge!(
  preserve_styles: true,
  remove_ids: true,
  strategies: [:asset_pipeline]
)
