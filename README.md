# labSetup

**NOTE: This project is currently in progress and likely wont work as provided.**

The malware lab uses a Linux host operating system, with KVM based virtual machines.

The virtual machine templates are created using the unattend file mounted as an ISO alongside the Windows 10 and 11 install media.

Once installed and updated, copy the base install and create a VM per-purpose.
In this setup, creating a VM for "sandbox" and one for "analysis".

## VM Creation

Create the VM disk images manually so they start of sparse, and then point the VM to this image file.

```
qemu-img create -f qcow2 /var/lib/libvirt/images/disk.qcow2 10G
```

## Template Conifguration

Inside a Windows guest, I want to keep the disk files as small as possible.

Zero out the unused blocks.

```
sdelete.exe -z c:
```

Shrink the QCOW2 images back down.
```
qemu-img convert -O qcow2 disk.qcow2.orig disk.qcow2
```

---

## Sandbox Configuration

```
sysmon.exe -i sandbox_sysmon.xml -n <driver>
```

Enable powershell scriptblock loggng.

```
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v EnableScriptBlockLogging /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging" /v EnableModuleLogging /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" /v * /t REG_SZ /d "*" /f
```


## Sandbox Execution
To execute in the sandbox use the 

```bash
sandbox_execute.sh <sample>
```

```bash
virt-copy-out -a /path/to/overlay.qcow2 "win:C:\Users\Public\Desktop\malware_log.txt" /local/host/path/
```



