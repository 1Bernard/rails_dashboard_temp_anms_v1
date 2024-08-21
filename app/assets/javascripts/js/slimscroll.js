// Function for Slimscroll bar
$(document).ready(function(){
    $('#sidebar .sidebar-inner').slimScroll({
        height: '100%',
        size: '5px', // Smaller scrollbar width
        color: '#bbb', // Lighter scrollbar color
        opacity: 0.4, // Slightly more transparent
        alwaysVisible:!1,
        disableFadeOut:!1,
        railColor:"#333",
        railOpacity:.2,
        railDraggable:!0,
        allowPageScroll:!1,
        wheelStep:20,
        railBorderRadius:"7px",
        touchScrollStep:200,
        railVisible: true, // Show rail
        railColor: '#f8f9fa', // Lighter rail color
        railBorderRadius:"7px"
    });
});