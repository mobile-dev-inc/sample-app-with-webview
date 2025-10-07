import Foundation
import Network

class LocalHTTPServer {
    private var listener: NWListener?
    private let port: UInt16 = 8080
    var serverURL: URL? {
        return URL(string: "http://localhost:\(port)")
    }
    
    func start() {
        do {
            // Create listener on specified port
            let parameters = NWParameters.tcp
            parameters.allowLocalEndpointReuse = true
            listener = try NWListener(using: parameters, on: NWEndpoint.Port(rawValue: port)!)
            
            listener?.newConnectionHandler = { [weak self] connection in
                self?.handleConnection(connection)
            }
            
            listener?.start(queue: .global())
            print("Local HTTP server started on port \(port)")
            
        } catch {
            print("Failed to start server: \(error)")
        }
    }
    
    func stop() {
        listener?.cancel()
        listener = nil
        print("Local HTTP server stopped")
    }
    
    private func handleConnection(_ connection: NWConnection) {
        connection.start(queue: .global())
        
        // Read the HTTP request
        connection.receive(minimumIncompleteLength: 1, maximumLength: 4096) { [weak self] data, _, isComplete, error in
            if let data = data, !data.isEmpty {
                let request = String(data: data, encoding: .utf8) ?? ""
                print("Received request: \(request.prefix(100))")
                
                // Send HTTP response with HTML content
                self?.sendHTMLResponse(connection: connection)
            }
            
            if isComplete {
                connection.cancel()
            } else if let error = error {
                print("Connection error: \(error)")
                connection.cancel()
            }
        }
    }
    
    private func sendHTMLResponse(connection: NWConnection) {
        // Load HTML content from bundle
        guard let htmlPath = Bundle.main.path(forResource: "login", ofType: "html"),
              let htmlContent = try? String(contentsOfFile: htmlPath) else {
            sendErrorResponse(connection: connection)
            return
        }
        
        // Create HTTP response
        let httpResponse = """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: \(htmlContent.utf8.count)\r
        Connection: close\r
        \r
        \(htmlContent)
        """
        
        let responseData = httpResponse.data(using: .utf8)!
        
        connection.send(content: responseData, completion: .contentProcessed { error in
            if let error = error {
                print("Send error: \(error)")
            }
            connection.cancel()
        })
    }
    
    private func sendErrorResponse(connection: NWConnection) {
        let errorHTML = """
        <!DOCTYPE html>
        <html>
        <head><title>Error</title></head>
        <body><h1>404 - File Not Found</h1></body>
        </html>
        """
        
        let httpResponse = """
        HTTP/1.1 404 Not Found\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: \(errorHTML.utf8.count)\r
        Connection: close\r
        \r
        \(errorHTML)
        """
        
        let responseData = httpResponse.data(using: .utf8)!
        
        connection.send(content: responseData, completion: .contentProcessed { error in
            if let error = error {
                print("Send error: \(error)")
            }
            connection.cancel()
        })
    }
}