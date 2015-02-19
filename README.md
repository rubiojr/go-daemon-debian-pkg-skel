# go-daemon-debian-pkg-skel

Sample Debian package for Go daemons

1. Run `make update-deps` to pull deps into the `vendor/` directory
2. `git add vendor`
3. Run `make` to test the build
4. `make debpkg` to generate the Debian source package
