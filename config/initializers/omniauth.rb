Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    "416831687576-0j4rfs0qauja960b1d490jvei66orvso.apps.googleusercontent.com",
    "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",
    {
      scope: "email, profile",
      prompt: "select_account",
      image_aspect_ratio: "square",
      image_size: 50
    }
end
