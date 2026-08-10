return {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift' },
    root_markers = {
      { 'buildServer.json', '*.xcworkspace', '*.xcodeproj', 'Package.swift' },
      '.git',
    },
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = false,
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
