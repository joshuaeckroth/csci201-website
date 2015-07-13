function blinker() {
    $('.blinking').fadeOut(300).fadeIn(300);
}

setInterval(blinker, 600);

