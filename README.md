# PWRMgmt

LaptopPowerConfig.bat will detect if your computer is using battery or power outlet, and will change the refresh rate from there.

if you want to customize change the resolution and refresh rates in the file in these lines

call %~dp0\binaries\qures\qres.exe x=1920 y=1080 f=60


# Usage Example

In Throttlestop, you can set things up to switch profiles whether in battery or AC. In the script path, you can set this one up.

In Task scheduler, you can add a task to run this script whenever the power source changes
