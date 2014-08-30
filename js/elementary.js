$(function () {
    $paymentAmount = $('#paymentAmount');
    $paymentObject = $('#paymentObject');
    
    comparisons = [
        { value : 0, item : ':(' },
        { value : 1, item : 'Newspaper' },
        { value : 3, item : 'Coffee' },
        { value : 5, item : 'Cinema ticket' },
        { value : 10, item : 'A Meal' },
        { value : 20, item : 'A meal out' },
        { value : 40, item : 'I don\'t know...' }
    ];
    valueMap = []
    for (var i = 0, len = 20; i < len; i++) valueMap.push(i);
    for (var i = 20, len = 50; i < len; i += 5) valueMap.push(i);
    for (var i = 50, len = 100; i <= len; i += 10) valueMap.push(i);
    
    // Checkboxes
    $('<span class="checkStyle"></span>').insertAfter('input[type="checkbox"]');
    // Radios
    $('<span class="radioStyle"></span>').insertAfter('input[type="radio"]');
    // Slider
    $(".slider").slider({
        value: 10,
        min: 0,
        max: valueMap.length - 1,
        orientation: "horizontal",
        start: function () {
            $("html").css("cursor", "ew-resize");
        },
        stop: function () {
            $("html").css("cursor", "auto");
        },
        slide: function(event, ui) {
            var value = parseInt(valueMap[ui.value]);
            
            $paymentAmount.val(value + '.00');
            
            var i = comparisons.length;
            while (--i) {
                if (comparisons[i].value <= value)
                    break;
            }
            
            $paymentObject.html(comparisons[i].item);
        }
    });
    //nav
    $("nav a.nav-current-section").click (function () {
        $("nav ul").toggle ();
        return false;
    });
});