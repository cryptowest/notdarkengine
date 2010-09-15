;NotDarkEngine (notde) by CoreDuo v0.3.6
on *:load:{ echo -ae NotDarkEngine installed sucessfully... | dek 3 | fde }
alias wmiget {
  var %com = cominfo, %com2 = cominfo2, %com3 = cominfo3
  if ($com(%com)) { .comclose %com }
  if ($com(%com2)) { .comclose %com2 }
  if ($com(%com3)) { .comclose %com3 }
  .comopen %com WbemScripting.SWbemLocator
  var %x = $com(%com,ConnectServer,3,dispatch* %com2), %x = $com(%com2,ExecQuery,3,bstr*,select $prop from $1,dispatch* %com3), %x = $comval(%com3,$iif($2,$2,1),$prop)
  if ($com(%com)) { .comclose %com }
  if ($com(%com2)) { .comclose %com2 }
  if ($com(%com3)) { .comclose %com3 }
  return %x
}
alias biosvendor { dem Bios Vendor: $sysget(biosvendor) }
alias biosdate { dem Bios Date: $sysget(biosdate) }
alias biosversion { dem Bios Version: $sysget(biosversion) }
;Operating System Information
;----
alias stripslash {
  return $calc($len($wmiget(Win32_ComputerSystem).Username)-$pos($wmiget(Win32_ComputerSystem).Username,$chr(92)))
}
alias newuptime {
  if ($1 = hours) {
    if ($floor($calc($uptime(system,3) % 86400/3600)) == 1) {
      return $floor($calc($uptime(system,3) % 86400/3600)) hour
    }
    else {
      return $floor($calc($uptime(system,3) % 86400/3600)) hours
    }
  }
  if ($1 = minutes) {
    if ($floor($calc($uptime(system,3) % (3600*24) % 3600 / 60)) == 1) {
      return $floor($calc($uptime(system,3) % (3600*24) % 3600 / 60)) minute
    }
    else return $floor($calc($uptime(system,3) % (3600*24) % 3600 / 60)) minutes
  }
  if ($1 = seconds) {
    if ($floor($calc($uptime(system,3) % (3600*24) % 3600 % 60)) == 1) {
      return $floor($calc($uptime(system,3) % (3600*24) % 3600 % 60)) second
    }
    else {
      return $floor($calc($uptime(system,3) % (3600*24) % 3600 % 60)) seconds
    }
  }
  if ($1 = days) {
    if ($floor($calc($uptime(system,3)/(3600*24))) == 1) {
      return $floor($calc($uptime(system,3)/(3600*24) % 7)) day
    }
    else {
      return $floor($calc($uptime(system,3)/(3600*24) % 7)) days
    }
  }
  if ($1 = weeks) {
    if ($floor($calc($uptime(system,3)/(3600*24)/7)) == 1) {
      return $floor($calc($uptime(system,3)/(3600*24)/7)) week
    }
    else {
      return $floor($calc($uptime(system,3)/(3600*24)/7)) weeks
    }
  }

}

alias sysget {
  if ($1 = version) {
    if ((4.0 isin $wmiget(Win32_OperatingSystem).Version))  {
      return Windows 95 $wmiget(Win32_OperatingSystem).CSDVersion ( $+ $wmiget(Win32_OperatingSystem).Version $+ )
    }
    if ((4.10 isin $wmiget(Win32_OperatingSystem).Version)) {
      if ($wmiget(Win32_OperatingSystem).Version == 4.10.2222) {
        return Windows 98 Second Edition $wmiget(Win32_OperatingSystem).CSDVersion ( $+ $wmiget(Win32_OperatingSystem).Version $+ )
      }
      else { return Windows 98 $wmiget(Win32_OperatingSystem).CSDVersion ( $+ $wmiget(Win32_OperatingSystem).Version $+ ) }
    }
    if ($wmiget(Win32_OperatingSystem).CSDVersion >= 1) {
      return $remove($wmiget(Win32_OperatingSystem).Caption,Edition,Microsoft,(R),(TM),$chr(44),$chr(226),$chr(132),$chr(162),$chr(194),$chr(226),$chr(174)) $+ $chr(32) $+ SP $+ $remove($wmiget(Win32_OperatingSystem).CSDVersion,Service,Pack,$chr(32)) ( $+ $wmiget(Win32_OperatingSystem).Version $+ ) 
    }
    else { return $remove($wmiget(Win32_OperatingSystem).Caption,Edition,Microsoft,(R),(TM),$chr(44),$chr(226),$chr(132),$chr(162),$chr(194),$chr(226),$chr(174)) $+ $chr(32) $+ ( $+ $wmiget(Win32_OperatingSystem).Version $+ ) }
  }
  if ($1 = cpu) {
    if ($wmiget(Win32_Processor).Manufacturer == GenuineIntel) && (@ isin $wmiget(Win32_Processor).Name) {
      return $remove($gettok($wmiget(Win32_Processor).Name,$+(1-,$iif($findtok($wmiget(Win32_Processor).Name,@,$findtok($wmiget(Win32_Processor).Name,@,0,32),32),$calc($v1 -1))),32),(TM),(R),CPU,processor)  
    }
    if ($wmiget(Win32_Processor).Manufacturer == GenuineIntel) && (@ !isin $wmiget(Win32_Processor).Name) {
      return $remove($gettok($wmiget(Win32_Processor).Name,$+(1-,$iif($findtok($wmiget(Win32_Processor).Name,CPU,$findtok($wmiget(Win32_Processor).Name,CPU,0,32),32),$calc($v1 -1))),32),(TM),(R),processor)    
    }
    else return $remove($wmiget(Win32_Processor).Name,(R),(TM),Processor,Mobile,Technology,Dual,Core,Quad)
  }
  if ($1 = l2cache) {
    if ($wmiget(Win32_Processor).L2CacheSize >= 1024) {
      return $calc(($wmiget(Win32_Processor).L2CacheSize)/1024) MB
    }
    else { return $wmiget(Win32_Processor).L2CacheSize KB }
  }

  if ($1 = clockspeed) {
    if ($wmiget(Win32_Processor).CurrentClockSpeed >= 1000) {
      return $round($calc(($wmiget(Win32_Processor).CurrentClockSpeed)/1000),2) GHz
    }
    else { return $wmiget(Win32_Processor).CurrentClockSpeed MHz }
  }
  if ($1 = cpuload) {
    return $wmiget(Win32_Processor).LoadPercentage $+ %
  }
  if ($1 = sound) {
    if ($wmiget(Win32_SoundDevice).StatusInfo == 3) {
      return $wmiget(Win32_SoundDevice).Name
    }
    else { return No Audio Device Found! }
  }
  if ($1 = winuser) {

    return $wmiget(Win32_ComputerSystem).Username
  }
  if ($1 = pcname) {
    return $wmiget(Win32_ComputerSystem).Name
  }
  if ($1 = installdate) {
    return $asctime($ctime($iif($wmiget(Win32_OperatingSystem).InstallDate,$+($mid($ifmatch,7,2),/,$mid($ifmatch,5,2),/,$mid($ifmatch,1,4)) $+($mid($ifmatch,9,2),:,$mid($ifmatch,11,2),:,$mid($ifmatch,13,2)))),dddd $+ $chr(44) mmmm d yyyy h:mm TT)
  }
  if ($1 = luptime) {
    if ($newuptime(weeks) == 0 weeks) {
      return $newuptime(days) $newuptime(hours) $newuptime(minutes) $newuptime(seconds)
    }
    elseif ($newuptime(weeks) >= 1) && ($newuptime(days) == 0 days) {
      return $newuptime(weeks) $newuptime(hours) $newuptime(minutes) $newuptime(seconds)
    }
    elseif ($newuptime(days) == 0 days) {
      return $newuptime(hours) $newuptime(minutes) $newuptime(seconds)
    }
    elseif ($newuptime(days) == 0 days) && ($newuptime(hours) == 0 hours) {
      return $newuptime(minutes) $newuptime(seconds)
    }
    elseif ($newuptime(days) == 0 days) && ($newuptime(hours) == 0 hours) && ($newuptime(minutes) == 0 minutes) {
      return $newuptime(seconds)
    }
    else {
      return $newuptime(weeks) $newuptime(days) $newuptime(hours) $newuptime(minutes) $newuptime(seconds)
    }
  }
  if ($1 = uptime) {
    return $duration($uptime(system,3))
  }
  if ($1 = videocard) {
    return $wmiget(Win32_VideoController).Caption
  }
  if ($1 = monitor) {
    return $wmiget(Win32_DesktopMonitor).Caption
  }
  if ($1 = screenres) {
    return $wmiget(Win32_VideoController).CurrentHorizontalResolution $+ $chr(120) $+ $wmiget(Win32_VideoController).CurrentVerticalResolution $+ $chr(120) $+ $wmiget(Win32_VideoController).CurrentBitsPerPixel $+ bpp $wmiget(Win32_VideoController).CurrentRefreshRate $+ Hz
  }
  if ($1 = biosvendor) {
    return $wmiget(Win32_BIOS).Manufacturer
  }
  if ($1 = biosdate) {
    return $asctime($ctime($iif($wmiget(Win32_BIOS).ReleaseDate,$+($mid($ifmatch,7,2),/,$mid($ifmatch,5,2),/,$mid($ifmatch,1,4)) $+($mid($ifmatch,9,2),:,$mid($ifmatch,11,2),:,$mid($ifmatch,13,2)))),m/d/yyyy)
  }
  if ($1 = biosversion) {
    return $wmiget(Win32_BIOS).SMBIOSBIOSVersion
  }
  if ($1 = mobovendor) {
    return $wmiget(Win32_ComputerSystem).Manufacturer
  }
  if ($1 = mobomodel) {
    return $wmiget(Win32_ComputerSystem).Model
  }
  if ($1 = battery) {
    if ($wmiget(Win32_Battery).EstimatedRunTime != 71582788) {
      if ($wmiget(Win32_Battery).EstimatedRunTime >= 60) {
        return $floor($calc(($wmiget(Win32_Battery).EstimatedRunTime)/60)) hour $calc($wmiget(Win32_Battery).EstimatedRunTime % 60) minutes ( $+ $wmiget(Win32_Battery).EstimatedChargeRemaining $+ % $+ )
        } else {
        return $wmiget(Win32_Battery).EstimatedRunTime minutes ( $+ $wmiget(Win32_Battery).EstimatedChargeRemaining $+ % $+ )
        } else {
        return Unknown ( $+ $wmiget(Win32_Battery).EstimatedChargeRemaining $+ % $+ )
      }
    }
  }
}
alias memory {
  if ($1 = allphysical) {
    if ($round($calc(($wmiget(Win32_OperatingSystem).TotalVisibleMemorySize)/1024),0) >= 1024) {
      return $round($calc(($wmiget(Win32_OperatingSystem).TotalVisibleMemorySize)/1024/1024),1) $+ GB
    }
    else {
      return $round($calc(($wmiget(Win32_OperatingSystem).TotalVisibleMemorySize)/1024),0) $+ MB
    }
  }
  elseif ($1 = freephysical) {
    if ($round($calc(($wmiget(Win32_OperatingSystem).FreePhysicalMemory)/1024),0)) >= 1024) {
      return $round($calc(($wmiget(Win32_OperatingSystem).FreePhysicalMemory)/1024/1024),2) $+ GB
    }
    else {
      return $round($calc(($wmiget(Win32_OperatingSystem).FreePhysicalMemory)/1024),0) $+ MB
    }
  }
  elseif ($1 = usedphysical) {
    if ($calc($round($calc(($wmiget(Win32_OperatingSystem).TotalVisibleMemorySize)/1024),0)-$round($calc(($wmiget(Win32_OperatingSystem).FreePhysicalMemory)/1024),0)) >= 1024) {
      return $calc($round($calc(($wmiget(Win32_OperatingSystem).TotalVisibleMemorySize)/1024/1024),2)-$round($calc(($wmiget(Win32_OperatingSystem).FreePhysicalMemory)/1024/1024),2)) $+ GB
    }
    else {
      return $calc($round($calc(($wmiget(Win32_OperatingSystem).TotalVisibleMemorySize)/1024),0)-$round($calc(($wmiget(Win32_OperatingSystem).FreePhysicalMemory)/1024),0)) $+ MB
    }
  }
}
alias osver { dem Operating System: $sysget(version) }
alias winuser { dem Windows User: $sysget(winuser) }
alias osinfo { dem OS info: $sysget(winuser) on $sysget(version) }
alias uptime { dem Uptime: $strip($sysget(uptime)) }
alias luptime { dem Uptime: $strip($sysget(luptime)) }
alias record { dem Record Uptime: $de(record_uptime) }
alias winstall { dem Installed On: $sysget(installdate) }
alias winall { dem OS Info: $sysget(version) $+  [ $+ $sysget(winuser) $+ ] installed on  $+ $sysget(installdate) }
alias pcname { dem Computer Name: $sysget(pcname) }
;Central Processing Unit Information
;----
alias cpu { dem CPU: $sysget(cpu) }
alias cpuspeed { dem CPU Speed: $sysget(clockspeed) }
;alias cpudetail { dem CPU Details: $de(cpudetails) }
alias cpuload { dem CPU Load: $sysget(cpuload) }
;alias cpuarch { dem CPU Architecture: $de(cpuarchitech) }
alias cpucount { dem CPU Count: $de(cpucount) }
alias cpuinfo { dem CPU: $sysget(cpu) $+ , $sysget(clockspeed) $+ ,  $+ $sysget(l2cache) $+  ( $+ $sysget(cpuload) Load $+ ) }
alias l1cache { dem L1 Cache: $de(cpu_cache_l1) }
alias l2cache { dem L2 Cache: $sysget(l2cache) }
alias l3cache { dem L3 Cache: $de(cpu_cache_l3) }
alias cpu_socket { dem CPU Socket: $de(cpu_sockettype) }
alias cpu_cores { dem CPU Cores: $de(cpu_core_count) }
alias cpu_extclock { dem CPU External Clock: $de(cpu_external_clock) $+  MHz }
alias cpu_multiplier { dem CPU Multiplier: $de(cpu_multiplier) }
;Video Information
;----
alias monitor { dem Monitor: $sysget(monitor) }
alias videocard { dem Video Card: $sysget(videocard) }
alias res { dem Resolution: $sysget(screenres) }
alias video { dem Video: $sysget(monitor) on $sysget(videocard)  $chr(40) $+ $sysget(screenres) $+ $chr(41) }
;Sound Information
;----
alias soundcard { dem Sound Card: $sysget(sound) }
;Hard Drive Information
;----
alias hd { dem Hard Drives: $de(harddrive_space) }
alias hdspace { dem Hard Drive: $dll(deultimate.dll,harddrive_space_drive,$1) }
alias hdtotal { dem Total Free: $de(harddrive_space_free) $+ / $+ $de(harddrive_space_total) }
alias hdtotal2 { dem Total Free: $de(harddrive_space_free_exclude_network) $+ / $+ $de(harddrive_space_total_exclude_network) }
;Memory Information
;----
alias memload { dem Memory Load: $de(memory_load) }
alias mem { dem Avaliable Memory: $memory(freephysical) }
alias usedmem { dem Used Memory: $memory(usedphysical) }
alias totalmem { dem Total Memory: $memory(allphysical) }
alias memratio { dem RAM: Used: $memory(usedphysical) $+ / $+ $memory(allphysical) }
alias vmemratio { dem Virtual RAM: Used: $de(memory_virtual_used) $+ / $+ $de(memory_virtual_total) $+ MB }
alias memsum { dem RAM: Used: $memory(usedphysical) $+ / $+ $memory(allphysical) ( $+ $de(memory_load) Load $+ ) }
alias memslots { dem Total Memory Slots: $de(memory_slots) }
;Internet Connection Information
;----
alias conn { dem Connection: $de(adapter_info_all) }
alias chadapter { $de(adapter_change) }
alias totaldown { dem Total Downloaded: $de(bandwidth_down_total) $+ MB }
alias totalup { dem Total Uploaded: $de(bandwidth_up_total) $+ MB }
alias tottrans { msg $active  $+ $dek $+ Downloaded: $de(bandwidth_down_total) MB  $+ $dek $+  Uploaded: $de(bandwidth_up_total) MB }
alias band { 
  set %de.band.down $de(bandwidth_down_total)
  set %de.band.down.ticks $ticks
  .timer 1 1 de_band_calc_down
}
alias upband {
  set %de.band.up $de(bandwidth_up_total)
  set %de.band.up.ticks $ticks
  .timer 1 1 de_band_calc_up
}
alias totband { 
  set %de.band.up $de(bandwidth_up_total)
  set %de.band.up.ticks $ticks
  set %de.band.down $de(bandwidth_down_total)
  set %de.band.down.ticks $ticks
  .timer 1 1 de_band_calc_total 
}
alias de_band_calc_down {
  set %de.band.down2 $de(bandwidth_down_total)
  set %de.band.down.curr $calc( ( %de.band.down2 - %de.band.down ) * 1000000 / ( $ticks - %de.band.down.ticks ) )
  dem Current Downstream:  $+ $round( %de.band.down.curr,2 ) $+  KBytes/s 
  unset %de.band.down
  unset %de.band.down2
  unset %de.band.down.curr
  unset %de.band.down.ticks
}
alias de_band_calc_up {
  set %de.band.up2 $de(bandwidth_up_total)
  set %de.band.up.curr $calc( ( %de.band.up2 - %de.band.up ) * 1000000 / ( $ticks - %de.band.up.ticks ) )
  dem Current Upstream:  $+ $round( %de.band.up.curr,2 ) $+  KBytes/s
  unset %de.band.up
  unset %de.band.up2
  unset %de.band.up.curr
  unset %de.band.up.ticks
}
alias de_band_calc_total {
  set %de.band.down2 $de(bandwidth_down_total)
  set %de.band.down.curr $calc( ( %de.band.down2 - %de.band.down ) * 1000000 / ( $ticks - %de.band.down.ticks ) )
  set %de.band.up2 $de(bandwidth_up_total)
  set %de.band.up.curr $calc( ( %de.band.up2 - %de.band.up ) * 1000000 / ( $ticks - %de.band.up.ticks ) )
  dem Downstream:  $+ $round( %de.band.down.curr, 2 ) $+   KBytes/s  $+ $dek $+  Upstream:  $+ $round( %de.band.up.curr, 2 ) $+  KBytes/s
  unset %de.band.down
  unset %de.band.down2
  unset %de.band.down.curr
  unset %de.band.down.ticks
  unset %de.band.up
  unset %de.band.up2
  unset %de.band.up.curr
  unset %de.band.up.ticks
}
;Winamp Information
;----
alias wamp { dem Playing: $de(winamp) }
alias id3 { dem ID3: $de(id3_test) }
;Misc Functions
;----
alias about { action is using NotDarkEngine (notde) by CoreDuo v0.3.7 }
alias sys { dem OS: $sysget(version)  $+ $dek $+ CPU: $sysget(cpu) $+ , $sysget(clockspeed) $+ ,   $+ $sysget(l2cache) $+   $+  $+ $dek $+ Video: $sysget(videocard) $+  ( $+ $sysget(screenres) $+ )  $+ $dek $+ Sound:  $+ $sysget(sound)  $+ $dek $+ Memory: Used: $memory(usedphysical) $+ / $+ $memory(allphysical)  $+ $dek $+ Uptime: $sysget(uptime)  $+ $dek $+ HD Space: Free: $de(harddrive_space_free) $+ / $+ $de(harddrive_space_total)  $+ $dek $+ Connection: $de(adapter_info_all) }
;Mainboard Functions
;----
alias mobo_manu { dem Mainboard Vendor: $sysget(mobovendor) }
alias mobo_name { dem Mainboard Name: $sysget(mobomodel) }
alias mobo_ver { dem Mainboard Version: $de(mobo_version) }
;Beta Functions
;----
alias cdrom_drive { dem CDRom Drive: $de(cdrom_name) }
alias video_card_ram { dem Video Card RAM: $de(video_card_ram) $+  MB }
;Unsupport Functions
;----
alias batlife { dem Battery Life: $sysget(battery) }
;alias batcharge { dem Battery Charged: $de(BatteryChargeStatus) }
;alias batpower { dem AC Power: $de(ACPowerStatus) }
;Darkengine Core Functions (do not modify)
;----
alias fde { flushini de.ini }
alias de { return $dll(deultimate.dll,$1,_) }
alias dem { msg $active  $+ $dek $+  $+ $1- } 
alias deq { return $$?="Enter message/text" }
alias dek { if ($isid == $true) { return $readini(de.ini,options,color) } | if ($isid == $false) { writeini de.ini options color $remove($1,) | flushini de.ini } }
; Darkengine Script Menus
;---
menu channel,query {
  -
  DarkEngine DLL
  .-
  .System Information.:/sys
  .-
  Operating System
  ..Version:/osver
  ..Username:/winuser
  ..Install Date:/winstall
  ..Computer Name:/pcname
  ..-
  ..Show All:/winall
  Processor Details
  ..Name:/cpu
  ..Load:/cpuload
  ..Multiplier:/cpu_multiplier
  ..Clock Speed:/cpuspeed
  ..External Clock Speed:/cpu_extclock
  ..-
  ;..Model Details:/cpudetail
  ;..Architecture:/cpuarch
  ..Socket:/cpu_socket
  ..Total Cores:/cpu_cores
  ..-
  ..L1 Cache:/l1cache
  ..L2 Cache:/l2cache
  ..L3 Cache:/l3cache
  ..-
  ..Show All:/cpuinfo
  Memory
  ..Memory Load:/memload
  ..-
  ..Total Memory Used:/memratio
  ..Total Memory Slots:/memslots
  ..-
  ..Total Virtual Memory Used:/vmemratio
  ..-
  ..Show All Physical:/memsum
  Hard Drive
  ..Total Space (Local):/hdtotal2
  ..Total Space (Local + Networked):/hdtotal
  ..-
  ..Show All Drives: /hd
  Uptime
  ..System Uptime:/luptime
  ..-
  ..Record Uptime:/record
  Video
  ..Video Card:/videocard
  ..-
  ..Screen Resolution:/res
  ..Monitor Manufacturer:/monitor
  ..-
  ..Show All:/Video
  .Sound Card:/soundcard
  Internet
  ..Connection Info:/conn
  ..-
  ..Current Upstream Usage:/upband
  ..Current Downstream Usage :/band
  ..Current Bandwidth Usage:/totband
  ..-
  ..Total Transferred:/tottrans
  ..-
  ..Change Adapter:/chadapter
  Mainboard
  ..Manufacturer:/mobo_manu
  ..Product Name:/mobo_name
  ..Version:/mobo_ver
  Power
  ..Battery Life:/batlife
  System Bios
  ..Vendor:/biosvendor
  ..Date:/biosdate
  ..Version:/biosversion
  Beta Functions
  ..CDRom Drive:/cdrom_drive
  ..Video Card RAM:/video_card_ram
  .-
  Winamp
  ..Current Playing:/wamp
  .-
  Help
  ..About:/about
}
