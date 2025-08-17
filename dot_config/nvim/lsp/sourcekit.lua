return {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift', 'objc', 'objcpp' },
    root_markers = { 'buildServer.json', '*.xcworkspace', '*.xcodeproj', 'Package.swift', ".git" },
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
      textDocument = {
        diagnostic = {
          dynamicRegistration = true,
          relatedDocumentSupport = true,
        },
      },
    },
}
