-- =====================================================================================================
-- TITLE: filetypes.lua
-- ABOUT: Settings of  additional filetypes
-- =====================================================================================================

vim.filetype.add({
  extension = {
    csproj = "csproj",
    fsproj = "fsproj",
    props = "dotnetprops",
  },
  filename = {
    ["Directory.Build.props"] = "dotnetprops",
    ["Packages.props"] = "dotnetprops",
  },
})
