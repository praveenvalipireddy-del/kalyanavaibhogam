# Simple PowerShell HTTP Server for Live Website Preview
param(
    [int]$Port = 8080
)

$HostAddress = "http://localhost:$Port/"
$RootPath = $PSScriptRoot

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($HostAddress)

try {
    $listener.Start()
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host " 🌺 Dhana Laxmi Bridal & Festive Crafts - Live Web Server" -ForegroundColor Yellow
    Write-Host " Server is running live at: $HostAddress" -ForegroundColor Green
    Write-Host " Press Ctrl+C in this terminal to stop the server" -ForegroundColor Gray
    Write-Host "=======================================================" -ForegroundColor Cyan
    
    # Launch default web browser
    Start-Process $HostAddress
} catch {
    Write-Host "Port $Port is busy, trying port 8081..." -ForegroundColor Yellow
    $Port = 8081
    $HostAddress = "http://localhost:$Port/"
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($HostAddress)
    $listener.Start()
    Write-Host "Server running at: $HostAddress" -ForegroundColor Green
    Start-Process $HostAddress
}

$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".jpeg" = "image/jpeg"
    ".jpg"  = "image/jpeg"
    ".png"  = "image/png"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".json" = "application/json"
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $rawPath = [System.Uri]::UnescapeDataString($request.Url.LocalPath)
        if ($rawPath -eq "/" -or $rawPath -eq "") {
            $rawPath = "/index.html"
        }
        
        $localFilePath = Join-Path $RootPath ($rawPath.TrimStart('/').Replace('/', '\'))
        
        if (Test-Path $localFilePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($localFilePath).ToLower()
            $mime = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
            
            $bytes = [System.IO.File]::ReadAllBytes($localFilePath)
            $response.ContentType = $mime
            $response.ContentLength64 = $bytes.Length
            $response.StatusCode = 200
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
            $notFoundBytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.OutputStream.Write($notFoundBytes, 0, $notFoundBytes.Length)
        }
        $response.Close()
    } catch {
        # Catch and continue on client disconnects
    }
}
