# env
create a new repository on the command line

```
echo "# env" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/taskforpid/env.git
git push -u origin main
```               

update
```
git add .
git restore .
git commit -m "update"
git branch -M main
git remote add origin https://github.com/taskforpid/env.git
git branch -M main
git push -u origin main
```

worktree - you are not currently on a branch git pull
```
git checkout -b newbranch
git checkout master
git merge newbranch
git branch -d newbranch
```
patch 
```
pushd $ANDROID_ROOT/rpm/dhd
curl https://github.com/sailfishos-oneplus5/droid-hal-device/commit/f95c839f7be994d2020ccf877adad118d04e1d9a.patch | patch -p1 -f
popd
```
fdp 
```
git clone https://github.com/piggz/sailfish-fpd-community.git hybris/mw/sailfish-fpd-community
source build/envsetup.sh
export USE_CCACHE=1
lunch lineage_$DEVICE-user
make libbiometry_fp_api_32
hybris/mw/sailfish-fpd-community/rpm/copy-hal.sh

SDK
rpm/dhd/helpers/build_packages.sh --build=hybris/mw/sailfish-fpd-community --spec=rpm/droid-biometry-fp.spec --do-not-install
rpm/dhd/helpers/build_packages.sh --build=hybris/mw/sailfish-fpd-community --spec=rpm/sailfish-fpd-community.spec --do-not-install
```
