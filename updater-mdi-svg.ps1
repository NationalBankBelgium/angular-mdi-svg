# Download getting-started page
$url = "https://raw.githubusercontent.com/Templarian/MaterialDesign/master/site/getting-started.savvy"
$output = "getting-started.savvy"
Invoke-WebRequest -Uri $url -OutFile $output

# Find the url for mdi.svg in case of change
$c = [string]::join("`n", (Get-Content $output))
$c -match "(\/api\/download\/angularmaterial\/[^\.)]+)"

if ($matches[0].length -gt 20) {
    # Download mdi.svg based on url if $matches[0] exists
    $svgUrl = "https://materialdesignicons.com" + $matches[0]
    $svgOutput = "mdi.svg"
    Invoke-WebRequest -Uri $svgUrl -OutFile $svgOutput

    git diff --quiet
    if (!$?) {
        git add .\mdi.svg
        git commit -m "automatic new mdi.svg version"
        git push origin master
        npm version minor
        npm publish --access public
    }
}

Remove-Item $output