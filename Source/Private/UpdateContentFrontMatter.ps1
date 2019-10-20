function UpdateContentFrontMatter() {
    <#
        .SYNOPSIS
            Replaces the PlatyPS generated front matter with Docusaurus compatible front matter.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $True)][string]$CustomEditUrl
    )

    # convenience variables
    $powershellCommandName = [System.IO.Path]::GetFileNameWithoutExtension($markdownFile.Name)

    $newFrontMatter = @(
        "---"
        "id: $powershellCommandName"
        "title: $powershellCommandName"
        "custom_edit_url: $customEditUrl"
        "---"
    )

    # read markdown into memory
    $content = Get-Content $MarkdownFile.FullName

    # keep everything AFTER front matter
    $frontMatterBlock = @($content | Select-String "^---$" | Select-Object -First 2)
    $content = $content[($frontMatterBlock[1].LineNumber +1) .. ($content.Length -1 )]

    # add new front matter
    $content = $newFrontMatter + $content

    # replace file content (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $content, $fileEncoding)
}
