# Configure OpenSSH server in TinkerELEC / LibreELEC

I wanted to set `ClientAliveInterval` and `ClientAliveCountMax` for sshd and this is the way I did it.

You normally would edit `/etc/ssh/sshd_config`, but on TinkerELEC / LibreELEC this is a read only system file.

Another way would be the configuration of `SSH_ARGS` here: `/storage/.cache/services/sshd.conf`

But this file gets frequently overwritten by the `service.libreelec.settings` kodi addon.

So one reliable way I found was to override the default `sshd.service` file.

To do this, you have to copy the file into `/storage/.config/system.d` like so:
```sh
cp /usr/lib/systemd/system/sshd.service /storage/.config/system.d/
```

You can now edit this file and add the changes you wish.

> [!CAUTION]
> If you misconfigure the arguments, the sshd service won't start, so you'd lose access to the system over ssh.

If you are confident that everything is configured correctly, reboot the system.

To check if sshd started with your arguments: `ps | grep sshd`

Output should show something similar like this:

`sshd: /usr/sbin/sshd -D -o ClientAliveInterval 120 -o ClientAliveCountMax 2 [listener] 0 of 10-100 startups`

## Content of: /storage/.config/system.d/sshd.service

```ini
[Unit]
Description=OpenSSH server daemon
After=network.target

[Service]
Restart=on-failure
EnvironmentFile=-/storage/.cache/services/sshd.conf
ExecStartPre=/usr/bin/ssh-keygen -A
ExecStart=/usr/sbin/sshd -D -o 'ClientAliveInterval 120' -o 'ClientAliveCountMax 2' $SSH_ARGS
ExecReload=/bin/kill -HUP $MAINPID
TimeoutStopSec=1s
RestartSec=2
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
```
