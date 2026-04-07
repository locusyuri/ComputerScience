<#
.SYNOPSIS
    Scans a source directory for module subdirectories, finds PDF files parallel to main.typ,
    and copies them to a new destination directory with new names based on the parent folder.

.DESCRIPTION
    This script processes a specific folder structure.
    The source directory is expected to contain category folders (e.g., '01-计算机基础').
    Each category folder is expected to contain module folders (e.g., 'Java').
    Each module folder is expected to have a 'main.pdf' file parallel to 'main.typ'.

    The script will:
    1. Iterate through each module in each category.
    2. Find the 'main.pdf' file (parallel to main.typ).
    3. Copy this PDF to a destination directory.
    4. The destination folder will be cleared before export starts.
    5. The destination structure will mirror the categories (e.g., 'Destination\01-计算机基础\').
    6. The copied file will be renamed to match its parent folder's name (e.g., 'Java.pdf').
    7. Original source files and folders will not be modified.

.PARAMETER SourceRoot
    The path to the root folder containing the category subdirectories. This is a mandatory parameter.

.PARAMETER DestinationRoot
    The path to the output folder where the renamed PDFs will be saved. The script will create this folder if it doesn't exist,
    then clear its existing contents before copying. This is a mandatory parameter.

.EXAMPLE
    .\remove.ps1 -SourceRoot "C:\MyNotes\ComputerScience" -DestinationRoot "D:\PDF\ComputerScience"

    This command will scan the "C:\MyNotes\ComputerScience" directory and output the processed PDF files
    into "D:\PDF\ComputerScience", preserving the category structure.
#>
[CmdletBinding()]
param ()

$SourceRoot = "C:\Users\Violet\OneDrive\Notiz\ComputerScience"
$DestinationRoot = "C:\Users\Violet\WPSDrive\1774341244\WPS企业云盘\哈尔滨工业大学\我的企业文档\PDF\ComputerScience"

$ignoreFolders = @("99-索引与模板", "ForCopy", "ForCopyTypst", "TexTemplate", "TypstTemplate", ".gitignore")

# --- Validation ---
if (-not (Test-Path -Path $SourceRoot -PathType Container)) {
    Write-Error "Source directory not found: $SourceRoot"
    return
}

if (-not (Test-Path -Path $DestinationRoot -PathType Container)) {
    New-Item -Path $DestinationRoot -ItemType Directory -Force | Out-Null
}

$destinationItems = Get-ChildItem -Path $DestinationRoot -Force -ErrorAction SilentlyContinue
if ($destinationItems) {
    Write-Host "Clearing destination folder: $DestinationRoot"
    Remove-Item -Path $destinationItems.FullName -Recurse -Force -ErrorAction Stop
}

# --- Main Processing ---
Write-Host "Starting PDF processing..."
Write-Host "Source: $SourceRoot"
Write-Host "Destination: $DestinationRoot"

$categoryFolders = Get-ChildItem -Path $SourceRoot -Directory | Where-Object { $ignoreFolders -notcontains $_.Name }

foreach ($categoryFolder in $categoryFolders) {
    Write-Host "`nProcessing category: $($categoryFolder.Name)"

    $moduleFolders = Get-ChildItem -Path $categoryFolder.FullName -Directory

    if ($moduleFolders.Count -eq 0) {
        Write-Warning "No module folders found in '$($categoryFolder.FullName)'."
        continue
    }

    foreach ($moduleFolder in $moduleFolders) {
        $moduleName = $moduleFolder.Name
        $mainPdfPath = Join-Path -Path $moduleFolder.FullName -ChildPath "main.pdf"
        $mainTypPath = Join-Path -Path $moduleFolder.FullName -ChildPath "main.typ"

        if (-not (Test-Path -Path $mainTypPath -PathType Leaf)) {
            continue
        }

        if (Test-Path -Path $mainPdfPath -PathType Leaf) {
            $destinationCategoryPath = Join-Path -Path $DestinationRoot -ChildPath $categoryFolder.Name

            if (-not (Test-Path -Path $destinationCategoryPath -PathType Container)) {
                Write-Host "  Creating destination category folder: $destinationCategoryPath"
                New-Item -Path $destinationCategoryPath -ItemType Directory -Force | Out-Null
            }

            $newPdfName = "$moduleName.pdf"
            $destinationPdfPath = Join-Path -Path $destinationCategoryPath -ChildPath $newPdfName

            Write-Host "  Found '$($mainPdfPath)'. Copying to '$($destinationPdfPath)'..."
            try {
                Copy-Item -Path $mainPdfPath -Destination $destinationPdfPath -Force -ErrorAction Stop
                Write-Host "  Successfully copied." -ForegroundColor Green
            }
            catch {
                Write-Error "  Failed to copy file for module '$moduleName'. Error: $_"
            }
        }
        else {
            Write-Warning "  'main.pdf' not found for module '$moduleName' at path '$mainPdfPath'."
        }
    }
}

Write-Host "`nProcessing complete."