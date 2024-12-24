#!/usr/bin/env sh
echo_exit() {
  >&2 echo "$*"
  exit 1
}

if [ $# -lt 1 ]; then
  echo_exit ./init.sh packagename
fi

PACKAGE_NAME=$1
echo Initializing app module...
go mod init "$PACKAGE_NAME" || echo_exit ERROR: go mod init failed.
sed -i "s/packagename/$PACKAGE_NAME/" cmd/main.go || echo_exit ERROR: substituting package name into cmd/main.go failed.
echo App module initialized successfully.

which templ > /dev/null 2>&1 || {
  echo Installing templ cli...
  go install github.com/a-h/templ/cmd/templ@latest || echo_exit ERROR: templ cli installation failed.
}

echo Fetching dependency packages...
for pckg in github.com/a-h/templ github.com/labstack/echo/v4 github.com/labstack/echo/v4/middleware; do
  go get "$pckg" || echo_exit ERROR: package \"$pckg\" installation failed.
done

which air > /dev/null 2>&1 || {
  echo Installing air cli...
  go install github.com/air-verse/air@latest || echo_exit ERROR: templ cli installation failed.
}
