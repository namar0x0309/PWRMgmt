# PWRMgmt

LaptopPowerConfig.bat will detect if your computer is using battery or power outlet, and will change the refresh rate from there.

if you want to customize change the resolution and refresh rates in the file in these lines

call %~dp0\binaries\qures\qres.exe x=1920 y=1080 f=60


# Usage Example

## Throttlestop
In Throttlestop, you can set things up to switch profiles whether in battery or AC. In the script path, you can set this one up.

![image](https://user-images.githubusercontent.com/580203/113180208-52687000-9205-11eb-9d2b-79129a1293a7.png)

In Task scheduler, you can add a task to run this script whenever the power source changes


## Windows Task Scheduler
Create a Task in the Task Scheduler and set it to trigger on this custom query

You need to find event that tracks the on battery or not ID
"Application and Services Logs">"Microsoft">"Windows">"UniversalTelemetryClient"

Then paste this in the Create Task, Custom Filter Window:

<QueryList>
<Query Id="0" Path="Microsoft-Windows-TaskScheduler/Operational">
    <Select Path="Microsoft-Windows-TaskScheduler/Operational">
		*[System[(EventID=60)]]
		and
		*[EventData[Data[@Name='State'] and (Data='true')]]
    </Select>
</Query>
</QueryList>

You can import the .xml in the Task Schedule and modify it if your ID isn't 60 (Windows 10 and 11's id is 60)