# Shell functions.sh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

finddot() {
    find . -name "$1"
}


# End.

