param (
    [string]$ftpServer = "ftp://marcotbz.bplaced.net",
    [string]$ftpUsername = "marcotbz",
    [string]$ftpPassword = "AatSlMwzvV6BsVwy",
    [string]$localFolder = ".",
    [string]$remoteFolder = "/test/"
)

function Upload-Files($localPath, $remotePath) {
    Write-Output "Uploading file: $localPath to $remotePath"

    $ftpWebRequest = [System.Net.FtpWebRequest]::Create("$ftpServer$remotePath")
    $ftpWebRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
    $ftpWebRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)

    $fileContents = Get-Content -Encoding Byte -Path $localPath
    $ftpWebRequest.ContentLength = $fileContents.Length

    try {
        $requestStream = $ftpWebRequest.GetRequestStream()
        $requestStream.Write($fileContents, 0, $fileContents.Length)
        $requestStream.Close()
        Write-Output "Successfully uploaded: $localPath"
    } catch {
        Write-Error "Error uploading file: $localPath. $_"
    }
}

function Upload-Directory($localDir, $remoteDir) {
    $items = Get-ChildItem -Path $localDir -File -Recurse

    foreach ($item in $items) {
        $relativePath = $item.FullName.Substring($localDir.Length)
        $remoteFilePath = $remoteDir + $relativePath -replace '\\', '/'
        $remoteFileDir = [System.IO.Path]::GetDirectoryName($remoteFilePath) -replace '\\', '/'

        Write-Output "Creating directory: $remoteFileDir"

        # Create remote directory structure
        $ftpWebRequest = [System.Net.FtpWebRequest]::Create("$ftpServer$remoteFileDir")
        $ftpWebRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $ftpWebRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
        try {
            $ftpWebRequest.GetResponse() | Out-Null
        } catch {
            Write-Output "Directory might already exist: $remoteFileDir"
        }

        Upload-Files -localPath $item.FullName -remotePath $remoteFilePath
    }
}

# Upload the directory, excluding node_modules
$localFilesToUpload = Get-ChildItem -Path $localFolder -File -Recurse | Where-Object { $_.FullName -notmatch "node_modules" }
foreach ($file in $localFilesToUpload) {
    $relativePath = $file.FullName.Substring($localFolder.Length)
    $remoteFilePath = $remoteFolder -replace '\\', '/'
    Upload-Files -localPath $file.FullName -remotePath $remoteFilePath
}

Write-Output "Files uploaded successfully!"
