param(
	[Parameter(Mandatory)] [string] $InputPath,
	[Parameter(Mandatory)] [string] $LargePath,
	[Parameter(Mandatory)] [string] $SmallPath
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

function Export-DdsBgra([System.Drawing.Bitmap] $Bitmap, [string] $Path) {
	$parent = Split-Path -Parent $Path
	if ($parent) { [IO.Directory]::CreateDirectory($parent) | Out-Null }

	$stream = [IO.File]::Create($Path)
	$writer = [IO.BinaryWriter]::new($stream)
	try {
		$writer.Write([uint32]0x20534444)
		$writer.Write([uint32]124)
		$writer.Write([uint32]0x100F)
		$writer.Write([uint32]$Bitmap.Height)
		$writer.Write([uint32]$Bitmap.Width)
		$writer.Write([uint32]($Bitmap.Width * 4))
		$writer.Write([uint32]0)
		$writer.Write([uint32]1)
		1..11 | ForEach-Object { $writer.Write([uint32]0) }
		$writer.Write([uint32]32)
		$writer.Write([uint32]0x41)
		$writer.Write([uint32]0)
		$writer.Write([uint32]32)
		$writer.Write([uint32]0x00FF0000)
		$writer.Write([uint32]0x0000FF00)
		$writer.Write([uint32]0x000000FF)
		$writer.Write([uint32]0xFF000000L)
		$writer.Write([uint32]0x1000)
		1..4 | ForEach-Object { $writer.Write([uint32]0) }

		$rect = [Drawing.Rectangle]::new(0, 0, $Bitmap.Width, $Bitmap.Height)
		$data = $Bitmap.LockBits($rect, [Drawing.Imaging.ImageLockMode]::ReadOnly, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
		try {
			$row = [byte[]]::new($Bitmap.Width * 4)
			for ($y = 0; $y -lt $Bitmap.Height; $y++) {
				$offset = if ($data.Stride -lt 0) { ($Bitmap.Height - 1 - $y) * -$data.Stride } else { $y * $data.Stride }
				[Runtime.InteropServices.Marshal]::Copy([IntPtr]::Add($data.Scan0, $offset), $row, 0, $row.Length)
				$writer.Write($row)
			}
		} finally {
			$Bitmap.UnlockBits($data)
		}
	} finally {
		$writer.Dispose()
		$stream.Dispose()
	}
}

function New-Portrait([Drawing.Image] $Source, [int] $Width, [int] $Height, [Drawing.Rectangle] $Crop) {
	$bitmap = [Drawing.Bitmap]::new($Width, $Height, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
	$graphics = [Drawing.Graphics]::FromImage($bitmap)
	try {
		$graphics.Clear([Drawing.Color]::Black)
		$graphics.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
		$graphics.PixelOffsetMode = [Drawing.Drawing2D.PixelOffsetMode]::HighQuality
		$graphics.DrawImage($Source, [Drawing.Rectangle]::new(0, 0, $Width, $Height), $Crop, [Drawing.GraphicsUnit]::Pixel)
	} finally {
		$graphics.Dispose()
	}
	$bitmap
}

function Assert-Dds([string] $Path, [int] $Width, [int] $Height) {
	$bytes = [IO.File]::ReadAllBytes($Path)
	if ([Text.Encoding]::ASCII.GetString($bytes, 0, 4) -ne 'DDS ' -or
		[BitConverter]::ToInt32($bytes, 16) -ne $Width -or
		[BitConverter]::ToInt32($bytes, 12) -ne $Height -or
		$bytes.Length -ne 128 + $Width * $Height * 4) {
		throw "DDS BGRA8 inválido: $Path"
	}
}

$source = [Drawing.Image]::FromFile((Resolve-Path -LiteralPath $InputPath))
try {
	$largeHeight = [Math]::Round($source.Width * 210 / 156)
	$largeCrop = [Drawing.Rectangle]::new(0, [Math]::Floor(($source.Height - $largeHeight) / 2), $source.Width, $largeHeight)
	$smallHeight = [Math]::Round($source.Height * 0.52)
	$smallWidth = [Math]::Round($smallHeight * 65 / 67)
	$smallCrop = [Drawing.Rectangle]::new([Math]::Floor(($source.Width - $smallWidth) / 2), [Math]::Round($source.Height * 0.10), $smallWidth, $smallHeight)

	$large = New-Portrait $source 156 210 $largeCrop
	$small = New-Portrait $source 65 67 $smallCrop
	try {
		Export-DdsBgra $large $LargePath
		Export-DdsBgra $small $SmallPath
		Assert-Dds $LargePath 156 210
		Assert-Dds $SmallPath 65 67
	} finally {
		$large.Dispose()
		$small.Dispose()
	}
} finally {
	$source.Dispose()
}
