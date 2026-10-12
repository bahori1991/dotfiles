-- =====================================================================================================
-- TITLE: vtsls.lua
-- ABOUT: settings of vtsls (typescript)
-- =====================================================================================================

return {
  settings = {
    typescript = {
      preferences = {
        useLabelDetailsInCompetionEntries = true,
        includeCompletionsForImportStatements = true,
      },
    },
    javascript = {
      preferences = {
        useLabelDetailsInCompetionEntries = true,
        includeCompletionsForImportStatements = true,
      },
    },
    vtsls = {
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 50,
        },
      },
    },
  },
}
