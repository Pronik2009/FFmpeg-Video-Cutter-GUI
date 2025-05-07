param(
    [string]$filePath = ""
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "FFmpeg Video Cutter"
$form.Size = New-Object System.Drawing.Size(370,320)
$form.StartPosition = "CenterScreen"

# Video file label + text
$labelFile = New-Object System.Windows.Forms.Label
$labelFile.Text = "Video file:"
$labelFile.Location = New-Object System.Drawing.Point(10,20)
$labelFile.Size = New-Object System.Drawing.Size(80,20)
$form.Controls.Add($labelFile)

$textFile = New-Object System.Windows.Forms.TextBox
$textFile.Location = New-Object System.Drawing.Point(100,20)
$textFile.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($textFile)

$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Text = "Browse"
$buttonBrowse.Location = New-Object System.Drawing.Point(100,45)
$buttonBrowse.Size = New-Object System.Drawing.Size(80,23)
$buttonBrowse.Add_Click({
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Filter = "MP4 files (*.mp4)|*.mp4|All files (*.*)|*.*"
    if ($ofd.ShowDialog() -eq "OK") {
        $textFile.Text = $ofd.FileName
        $textTo.Text = Get-VideoDuration $ofd.FileName
        $textFrom.Text = "00:00:00"
    }
})
$form.Controls.Add($buttonBrowse)

# Start time
$labelFrom = New-Object System.Windows.Forms.Label
$labelFrom.Text = "Start from (hh:mm:ss):"
$labelFrom.Location = New-Object System.Drawing.Point(10,80)
$labelFrom.Size = New-Object System.Drawing.Size(130,20)
$form.Controls.Add($labelFrom)

$textFrom = New-Object System.Windows.Forms.TextBox
$textFrom.Text = "00:00:00"
$textFrom.Location = New-Object System.Drawing.Point(140,80)
$textFrom.Size = New-Object System.Drawing.Size(100,20)
$form.Controls.Add($textFrom)

# Cut to time
$labelTo = New-Object System.Windows.Forms.Label
$labelTo.Text = "Cut until (hh:mm:ss):"
$labelTo.Location = New-Object System.Drawing.Point(10,110)
$labelTo.Size = New-Object System.Drawing.Size(130,20)
$form.Controls.Add($labelTo)

$textTo = New-Object System.Windows.Forms.TextBox
$textTo.Location = New-Object System.Drawing.Point(140,110)
$textTo.Size = New-Object System.Drawing.Size(100,20)
$form.Controls.Add($textTo)

# Overwrite checkbox
$checkboxOverwrite = New-Object System.Windows.Forms.CheckBox
$checkboxOverwrite.Text = "Overwrite original file"
$checkboxOverwrite.Checked = $true
$checkboxOverwrite.Location = New-Object System.Drawing.Point(100,140)
$checkboxOverwrite.Size = New-Object System.Drawing.Size(180,20)
$form.Controls.Add($checkboxOverwrite)

# Run button
$buttonRun = New-Object System.Windows.Forms.Button
$buttonRun.Text = "Trim"
$buttonRun.Location = New-Object System.Drawing.Point(100,180)
$buttonRun.Size = New-Object System.Drawing.Size(80,30)
$buttonRun.Add_Click({
    $input = $textFile.Text
    $startTime = $textFrom.Text
    $toTime = $textTo.Text
    $overwrite = $checkboxOverwrite.Checked

    if (-not (Test-Path $input)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a valid file.")
        return
    }

    $dir = [System.IO.Path]::GetDirectoryName($input)
    $name = [System.IO.Path]::GetFileNameWithoutExtension($input)
    $ext = [System.IO.Path]::GetExtension($input)

    if ($overwrite) {
        $output = $input
        $temp = Join-Path $dir ($name + "_tmp" + $ext)
        $cmd = "ffmpeg -y -ss $startTime -i `"$input`" -to $toTime -c copy `"$temp`" && move /Y `"$temp`" `"$output`""
    } else {
        $output = Join-Path $dir ($name + "_cut" + $ext)
        $cmd = "ffmpeg -y -ss $startTime -i `"$input`" -to $toTime -c copy `"$output`""
    }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "cmd.exe"
    $psi.Arguments = "/c $cmd"
    $psi.WindowStyle = 'Hidden'
    $psi.CreateNoWindow = $true
    $psi.UseShellExecute = $false
    [System.Diagnostics.Process]::Start($psi) | Out-Null

    $form.Close()
})
$form.Controls.Add($buttonRun)

$form.AcceptButton = $buttonRun

# Duration helper
function Get-VideoDuration {
    param([string]$file)
    $ffmpegOutput = & ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 `"$file`"
    $seconds = [math]::Floor([double]$ffmpegOutput)
    [timespan]::FromSeconds($seconds).ToString("hh\:mm\:ss")
}

# If file passed as argument
if ($filePath -and (Test-Path $filePath)) {
    $textFile.Text = $filePath
    $textTo.Text = Get-VideoDuration $filePath
    $textFrom.Text = "00:00:00"
}

$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
