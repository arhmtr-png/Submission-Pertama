Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Mouse {
    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int X, int Y);
    [DllImport("user32.dll")]
    public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, UIntPtr dwExtraInfo);
    public const uint MOUSEEVENTF_LEFTDOWN = 0x02;
    public const uint MOUSEEVENTF_LEFTUP = 0x04;
}
"@
[Mouse]::SetCursorPos(300,220)
Start-Sleep -Milliseconds 200
[Mouse]::mouse_event([Mouse]::MOUSEEVENTF_LEFTDOWN,0,0,0,[uintptr]::Zero)
Start-Sleep -Milliseconds 100
[Mouse]::mouse_event([Mouse]::MOUSEEVENTF_LEFTUP,0,0,0,[uintptr]::Zero)
Write-Output "Clicked at 300,220"
