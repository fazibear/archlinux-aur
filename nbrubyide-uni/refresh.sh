# Contributor: FaziBear <fazibear@gmail.com>

# makepkg configuration
[ -f /etc/makepkg.conf ] && source /etc/makepkg.conf

# main functions
update_pb() {
  sed -i "1,11 s/pkgver=$oldpkgver/pkgver=$1/" ./PKGBUILD
}

revert_pb() {
  sed -i "1,11 s/pkgver=$1/pkgver=$oldpkgver/" ./PKGBUILD
  exit 1
}

if [ -f ./PKGBUILD ]; then
  source PKGBUILD || exit 1
else
  exit 1
fi

oldpkgver=$pkgver
newpkgver=`wget -q -O - "$_hudson_url/job/$_hudson_job/lastSuccessfulBuild/buildNumber"`

if [ "$oldpkgver" != "$newpkgver" ]; then
  update_pb $newpkgver
  makepkg || revert_pb $newpkgver
  exit 0
fi

exit 0
