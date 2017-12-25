#!/bin/bash
set -e

source ./pcopr.config

tmp_file=$(date +%s).txt
if [ -f $tmp_file ]; then
	exit 1
fi

last_tag_resolve()
{
	cd $DIR_REPO_SRC
	echo $(git describe --tags $PATCH_BRANCH_BASE_SRC)
	cd ..
}

pkg_git_sha1_resolve()
{
	echo $(koji buildinfo $1 | grep "Task:" | awk -F: '{ print $3 }' | \
		cut -c -12)
}

copr_pkg_ver_resolve()
{
	echo $(cat $tmp_file | grep "version:" | awk -F: '{ print $2 }' | \
		cut -c 2-)
}

tree_tag()
{
	local remote=$(echo $PATCH_BRANCH_LIST | awk -F/ '{ print $1 }')
	local branch=$(echo $PATCH_BRANCH_LIST | awk -F/ '{ print $2 }')

	cd $DIR_REPO_SRC
	git branch -D tmp &> /dev/null
	git checkout -b tmp -t $PATCH_BRANCH_LIST
	git tag $ver
	git push --tags $remote tmp:$branch
	cd ..
}

# Resolve the last tag in the 'rawhide' branch in Fedora's exploded
# git tree.
tag=$(last_tag_resolve)
fc=$(echo $tag | rev | cut -c -4 | rev)
echo "Last tag:" $tag


# Resolve the corresponding pkg-git sha1sum for the build.
sha1=$(pkg_git_sha1_resolve $tag)
echo "Corresponding sha1sum:" $sha1

./pcopr_patch
./pcopr_srpm-kernel_fedora -B -R $sha1 -V | tee $tmp_file

# Resolve COPR package version
ver=kernel-$(copr_pkg_ver_resolve).${fc}
echo "COPR package version:" $ver
rm $tmp_file

# Tag our git tree with the version.
tree_tag $ver

echo "Done"
