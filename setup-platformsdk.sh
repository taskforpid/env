#!/bin/sh

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

#Setup environment
rm ~/.hadk.env
rm ~/.mersdk.profile
rm ~/.mersdkubu.profile
ln -s $SCRIPTPATH/.hadk.env ~/.hadk.env
ln -s $SCRIPTPATH/.mersdk.profile ~/.mersdk.profile
ln -s $SCRIPTPATH/.mersdkubu.profile ~/.mersdkubu.profile

source ~/.hadk.env

mkdir -p $MER_TMPDIR
mkdir -p $ANDROID_ROOT/.repo/local_manifests
cp $SCRIPTPATH/enchilada.xml $ANDROID_ROOT/.repo/local_manifests/enchilada.xml
cp $SCRIPTPATH/oneplus_sdm845-common.xml $ANDROID_ROOT/.repo/local_manifests/oneplus_sdm845-common.xml

#Download Setup MER SDK
cd $MER_TMPDIR
TARBALL=Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2 
curl -k -O -C - http://releases.sailfishos.org/sdk/installers/latest/$TARBALL

SDK_ROOT=$PLATFORM_SDK_ROOT/sdks/sfossdk
sudo mkdir -p $PLATFORM_SDK_ROOT/{targets,toolings}
sudo rm -rf $SDK_ROOT
mkdir -p $SDK_ROOT
sudo ln -s $PLATFORM_SDK_ROOT/sdks/sfossdk/$PLATFORM_SDK_ROOT/sdks/ubuntu/ $PLATFORM_SDK_ROOT/sdks/ubuntu
cd $SDK_ROOT
sudo tar --numeric-owner -p -xjf $MER_TMPDIR/$TARBALL

#Setup convenience bash aliases
echo "export PLATFORM_SDK_ROOT=$PLATFORM_SDK_ROOT" >> ~/.bashrc
echo "alias sfossdk=$SDK_ROOT/mer-sdk-chroot" >> ~/.bashrc

cd $HOME

sudo chroot $SDK_ROOT sudo zypper ref -f
sudo chroot $SDK_ROOT sudo zypper --non-interactive in bc pigz atruncate android-tools-hadk

echo "SailfishOS Platform SDK setup complete. You can start Sailfish OS SDK by simply typing sfossdk on your bash shell. Good Luck!"
exec bash