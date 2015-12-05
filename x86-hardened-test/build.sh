suffix=hardened
arch=$1
busybox_version=$2
dist="http://distfiles.gentoo.org/releases/${arch}/autobuilds/"
stage3="$(wget -q -O- ${dist}/latest-stage3-${busybox_version}${suffix}.txt | tail -n 1 | cut -f 1 -d ' ')"

mkdir newWorldOrder; cd newWorldOrder
echo "Downloading and extracting ${stage3}..."
wget -q -c "${dist}/${stage3}"
bunzip2 -c $(basename ${stage3}) | tar --exclude "./etc/hosts" --exclude "./sys/*" -xf -
rm -f $(basename ${stage3})
#Add portage
wget -q -c  http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2
bzcat /newWorldOrder/portage-latest.tar.bz2 | tar -xf - -C /newWorldOrder/usr
mkdir -p usr/portage/distfiles usr/portage/metadata /usr/portage/packages
wget -O poweriso-1.3.tar.gz http://goo.gl/p8Tzc
tar -xzvf poweriso-1.3.tar.gz -C /usr/local/bin
chmod +x /usr/local/bin/poweriso
#Busy Box
wget -q -O /busybox "http://www.busybox.net/downloads/binaries/latest/busybox-${busybox_version}"
chmod +x /busybox
/busybox rm -rf /lib* /usr /var /bin /sbin /opt /mnt /media /root /home /run /tmp
/busybox cp -fRap lib* /
/busybox cp -fRap bin boot home media mnt opt root run sbin tmp usr var /
/busybox cp -fRap etc/* /etc/
cd /
#commit suicide
/busybox rm -rf newWorldOrder /busybox /build.sh /linuxrc

# Self destruct
rm -f /Dockerfile /build.sh

echo "Bootstrapped ${stage3} into /:"
ls --color -lah
