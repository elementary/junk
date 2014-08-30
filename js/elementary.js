$(function () {
    //nav
    $("nav a.nav-current-section").click (function () {
        $("nav ul").toggle ();
        return false;
    });
});