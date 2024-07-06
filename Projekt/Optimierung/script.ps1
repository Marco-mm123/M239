# Step 1: Minify all CSS files using css-minify (assuming css-minify is installed and available in the path)
Invoke-Expression "css-minify -d ./ -o ./"

# Step 2: Delete all .css files except those ending in .min.css
Get-ChildItem -Path . -Filter "*.css" | Where-Object { $_.Name -notlike "*.min.css" } | Remove-Item

# Step 3: Rename all .min.css files to .css
Get-ChildItem -Path . -Filter "*.min.css" | ForEach-Object {
    $newName = $_.Name -replace "\.min\.css$", ".css"
    Rename-Item -Path $_.FullName -NewName $newName
}

Write-Output "Done!"
