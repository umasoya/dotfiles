md() {
    pandoc $1 -s | w3m -T text/html
}
