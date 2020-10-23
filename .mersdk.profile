function hadk() { source $HOME/.hadk.env; echo "Env setup for $DEVICE"; }
hadk

PS1="TBCC SDK $PS1"

if [ -d /etc/bash_completion.d ]; then
   for i in /etc/bash_completion.d/*;
   do
      . $i
   done
fi

export RELEASE=`cat /etc/os-release | grep VERSION_ID | cut -d"=" -f2`
export PLATFORM_SDK_ROOT=$MER_ROOT
export ANDROID_ROOT=$MER_ROOT/android/droid

remote="https://github.com/sailfish-oneplus6"

sdk_prompt() { echo "$1: enter HA_BUILD env first by typing 'ha_build' & try again (or override with '\\$@')!"; }

alias mka="sdk_prompt mka"
alias enter_habuildsdk="ubu-chroot -r $HABUILD_ROOT"
alias enter_scratchbox="sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R"
alias bp="rpm/dhd/helpers/build_packages.sh"

#TODO add error checks

pushd () {
  command pushd "$@" > /dev/null
}

popd () {
  command popd "$@" > /dev/null
}

die () {
  if [ -z "$*" ]; then
    echo "command failed at `date`, dying..."
  else
    echo "$*"
  fi
  exit 1
}


function setup_ubuntuchroot {
  mkdir -p $MER_TMPDIR
  pushd $MER_TMPDIR
  TARBALL=ubuntu-trusty-20180613-android-rootfs.tar.bz2
  sudo ln -s $PLATFORM_SDK_ROOT/sdks/sfossdk/$PLATFORM_SDK_ROOT/sdks/ubuntu/ $PLATFORM_SDK_ROOT/sdks/ubuntu
  curl -k -O -C - https://releases.sailfishos.org/ubu/$TARBALL || die "Error downloading ubuntu rootfs"
  sudo rm -rf $HABUILD_ROOT
  sudo mkdir -p $HABUILD_ROOT
  sudo tar --numeric-owner -xvjf $TARBALL -C $HABUILD_ROOT
  sudo sed "s/\tlocalhost/\t$(</parentroot/etc/hostname)/g" -i $UBUNTU_CHROOT/etc/hosts
  sudo zypper ref -f
  sudo zypper --non-interactive in bc pigz atruncate android-tools-hadk kmod
  ubu-chroot -r $HABUILD_ROOT /bin/bash -c "echo Installing useful tools && sudo apt-get update"
  popd
}

function setup_repo {
  mkdir -p $ANDROID_ROOT
  sudo chown -R $USER $ANDROID_ROOT
  ubu-chroot -r $HABUILD_ROOT /bin/bash -c "echo Installing repo && curl -O https://storage.googleapis.com/git-repo-downloads/repo && chmod a+x repo && sudo mv repo /usr/bin"
}

function fetch_sources {
  ubu-chroot -r $HABUILD_ROOT /bin/bash -c "echo Initializing repo && cd $ANDROID_ROOT && repo init -u git://github.com/mer-hybris/android.git -b $HYBRIS_BRANCH --depth 1"
  ubu-chroot -r $HABUILD_ROOT /bin/bash -c "echo Syncing sources && cd $ANDROID_ROOT && repo sync -c -j`nproc` --fetch-submodules --no-clone-bundle --no-tags && hybris-patches/apply-patches.sh --mb && git clone --recurse-submodules https://github.com/mer-hybris/libhybris $HYBRIS_MW_ROOT/libhybris"
}

function setup_scratchbox {
  mkdir -p $MER_TMPDIR
  pushd $MER_TMPDIR

  sdk-manage target install $VENDOR-$DEVICE-$PORT_ARCH http://releases.sailfishos.org/sdk/targets/Sailfish_OS-$RELEASE-Sailfish_SDK_Target-$PORT_ARCH.tar.7z --tooling SailfishOS-$RELEASE --tooling-url http://releases.sailfishos.org/sdk/targets/Sailfish_OS-$RELEASE-Sailfish_SDK_Tooling-i486.tar.7z

  popd
}

function test_scratchbox {
  mkdir -p $MER_TMPDIR
  pushd $MER_TMPDIR

  cat > main.c << EOF
#include <stdlib.h>
#include <stdio.h>
int main(void) {
printf("Scratchbox, works!\n");
return EXIT_SUCCESS;
}
EOF

  sb2 -t $VENDOR-$DEVICE-$PORT_ARCH gcc main.c -o test
  sb2 -t $VENDOR-$DEVICE-$PORT_ARCH ./test

  popd
}

function build_hybrishal {
  ubu-chroot -r $HABUILD_ROOT /bin/bash -c "echo Building hybris-hal && cd $ANDROID_ROOT && source build/envsetup.sh && breakfast $DEVICE && export USE_CCACHE=1 && mka hybris-hal"
}

function kern_patch {
  pushd $ANDROID_ROOT/rpm/dhd
ubu-chroot -r $HABUILD_ROOT /bin/bash -c "curl https://github.com/sailfishos-oneplus5/droid-hal-device/commit/f95c839f7be994d2020ccf877adad118d04e1d9a.patch | patch -p1 -f"
popd
}


function help {
  echo "Welcome to TBCC SDK"
  echo "Additional convenience functions defined here are:"
  echo "  1) setup_ubuntuchroot: set up ubuntu chroot for painless building of android"
  echo "  2) setup_repo: sets up repo tool in ubuntu chroot to fetch android/mer sources"
  echo "  3) fetch_sources: fetch android/mer sources"
  echo "  4) setup_scratchbox: sets up a cross compilation toolchain to build mer packages"
  echo "  5) test_scratchbox: tests the scratchbox toolchain."
  echo "  6) build_hybrishal: builds the hybris-hal needed to boot sailfishos for $DEVICE"
  echo "  kern_patch"
  echo "  help) Show this help"
}

cd $ANDROID_ROOT
echo "Type help"