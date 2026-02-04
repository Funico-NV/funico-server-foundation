//
//  ServerStateHolder.swift
//  funico-server-foundation
//
//  Created by Damian Van de Kauter on 04/02/2026.
//

import Vapor

extension Application {
    
    public func exposeDocumentation(file openapiFile: String = "openapi", extension openapiExtension: String = "yaml", in bundle: Bundle) {
        get("api", "\(openapiFile)") { req async throws -> Response in
            guard let url = bundle.url(forResource: openapiFile, withExtension: openapiExtension) else {
                var headers = HTTPHeaders()
                headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
                let message = """
                OpenAPI specification not found in the app bundle.
                """
                return Response(status: .notFound, headers: headers, body: .init(string: message))
            }

            let path = url.path
            let fm = FileManager.default
            guard fm.fileExists(atPath: path) else {
                var headers = HTTPHeaders()
                headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
                let message = """
                OpenAPI specification URL resolved, but file does not exist on disk.

                Resolved path: \(path)
                """
                return Response(status: .notFound, headers: headers, body: .init(string: message))
            }

            do {
                return try await req.fileio.asyncStreamFile(at: path, mediaType: .init(type: "application", subType: openapiExtension))
            } catch {
                req.logger.error("Failed to stream OpenAPI spec: \(error)")
                
                var headers = HTTPHeaders()
                headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
                let message = """
                Failed to stream the bundled OpenAPI specification.

                Resolved path: \(path)
                Error: \(error)
                """
                return Response(status: .internalServerError, headers: headers, body: .init(string: message))
            }
        }
        
        get("api", "docs") { req -> Response in
            let html = """
            <!DOCTYPE html>
            <html>
            <head>
              <meta charset=\"utf-8\" />
              <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />
              <title>API Docs</title>
              <link rel=\"stylesheet\" href=\"https://unpkg.com/swagger-ui-dist@5/swagger-ui.css\" />
              <style>html, body, #swagger-ui { height: 100%; margin: 0; }</style>
            </head>
            <body>
              <div id=\"swagger-ui\"></div>
              <script src=\"https://unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js\"></script>
              <script>
                window.onload = () => {
                  window.ui = SwaggerUIBundle({
                    url: '/api/\(openapiFile)',
                    dom_id: '#swagger-ui',
                    deepLinking: true,
                    presets: [SwaggerUIBundle.presets.apis],
                  });
                };
              </script>
            </body>
            </html>
            """
            var headers = HTTPHeaders()
            headers.replaceOrAdd(name: .contentType, value: "text/html; charset=utf-8")
            return Response(status: .ok, headers: headers, body: .init(string: html))
        }
    }
}
