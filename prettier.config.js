const decidimPrettier = require("@decidim/prettier-config");

module.exports = {
  ...decidimPrettier,
  overrides: [
    ...(decidimPrettier.overrides || []),
    {
      files: "*.scss",
      options: {
        parser: "scss",
        singleQuote: false
      }
    }
  ]
};
