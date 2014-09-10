$(function () {

    /*******
     * NAV *
     *******/

    $("nav a.nav-current-section").click (function () {
        $("nav ul").toggle ();
        return false;
    });

    /*****************
     * SMOOTH SCROLL *
     *****************/

    $('a.navigate-document').click(function () {
        $('html, body').animate({
            scrollTop: $( $.attr(this, 'href') ).offset().top
        }, {
            duration: 500,
            easing: 'swing'
        });
        return false;
    });
});
