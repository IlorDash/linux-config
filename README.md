# Linux config

My Linux config basically for Linux Mint Mate.

## Change screen resolution in Hyper-V VM

To setup Full HD resolution in Hyper-V Linux Mint VM execute:
```bash
if sudo grep -q '^GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub; then
sudo sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet video=hyperv_fb:1920x1080"|' /etc/default/grub
else
	echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet video=hyperv_fb:1920x1080"' | sudo tee -a /etc/default/grub > /dev/null
fi
sudo update-grub
```
