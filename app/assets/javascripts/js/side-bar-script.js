(function ($) {
  "use strict";

  // Cache DOM elements
  var $wrapper = $('.main-wrapper');
  var $slimScrolls = $('.slimscroll');

  jQuery(function () {
    // Handle sidebar menu item click
    $('#sidebar-menu a').on('click', function (e) {
      if ($(this).parent().hasClass('submenu')) {
        e.preventDefault();
      }
      if (!$(this).hasClass('subdrop')) {
        $('ul', $(this).parents('ul:first')).slideUp(350);
        $('a', $(this).parents('ul:first')).removeClass('subdrop');
        $(this).next('ul').slideDown(350);
        $(this).addClass('subdrop');
        // Hide the request badge when submenu is opened
        $(this).find('.req-side-bar-notification-badge').hide();
      } else if ($(this).hasClass('subdrop')) {
        $(this).removeClass('subdrop');
        $(this).next('ul').slideUp(350);
        // Show the request badge when submenu is closed
        $(this).find('.req-side-bar-notification-badge').show();
      }
    });

    // Ensure submenus with 'text-active' remain open
    $('#sidebar-menu ul li.submenu').each(function () {
      if ($(this).find('.text-active').length > 0) {
        $(this).children('a:first').addClass('subdrop');
        $(this).children('ul').slideDown(350);
        // Hide the request badge if the submenu is active
        $(this).children('a:first').find('.req-side-bar-notification-badge').hide();
      }
    });

    // Trigger click on active submenu
    $('#sidebar-menu ul li.submenu a.active').parents('li:last').children('a:first').addClass('active').trigger('click');
  });

  jQuery(function () {
    // Add sidebar overlay for mobile view
    $('body').append('<div class="sidebar-overlay"></div>');
  });

  // Handle mobile sidebar toggle button click
  $(document).on('click', '#mobile_btn', function () {
    $wrapper.toggleClass('slide-nav');
    $('.sidebar-overlay').toggleClass('opened');
    $('html').addClass('menu-opened');

    return false;
  });

  // Hide sidebar on overlay click
  $(".sidebar-overlay").on("click", function () {
    $wrapper.removeClass('slide-nav');
    $(".sidebar-overlay").removeClass("opened");
    $('html').removeClass('menu-opened');

  });

  // Set dynamic page height
  if ($('.page-wrapper').length > 0) {
    var height = $(window).height();
    $(".page-wrapper").css("min-height", height);
  }

  $(window).on('resize', function () {
    if ($('.page-wrapper').length > 0) {
      var height = $(window).height();
      $(".page-wrapper").css("min-height", height);
    }
  });

  // Initialize slimScroll
  if ($slimScrolls.length > 0) {
    $slimScrolls.slimScroll({
      height: 'auto',
      width: '100%',
      position: 'right',
      size: '7px',
      color: '#ccc',
      allowPageScroll: false,
      wheelStep: 10,
      touchScrollStep: 100
    });

    var wHeight = $(window).height() - 60;
    $slimScrolls.height(wHeight);
    $('.sidebar .slimScrollDiv').height(wHeight);

    $(window).on('resize', function () {
      var rHeight = $(window).height() - 60;
      $slimScrolls.height(rHeight);
      $('.sidebar .slimScrollDiv').height(rHeight);
    });
  }

  // Toggle mini sidebar
  $(document).on('click', '#toggle_menu_slidder', function () {
    if ($('body').hasClass('mini-sidebar')) {
      $('body').removeClass('mini-sidebar');
      $('.subdrop + ul').slideDown();
    } else {
      $('body').addClass('mini-sidebar');
      $('.subdrop + ul').slideUp();
    }
    return false;
  });

  $(document).on('mouseover', function (e) {

    e.stopPropagation();
    if ($('body').hasClass('mini-sidebar') && $('#toggle_menu_slidder').is(':visible')) {
      var targ = $(e.target).closest('.sidebar').length;
      if (targ) {
        $('body').addClass('expand-menu');
        $('.subdrop + ul').slideDown();
      } else {
        $('body').removeClass('expand-menu');
        $('.subdrop + ul').slideUp();
      }
      return false;
    }
  });

})(jQuery);

// Function for Slimscroll bar
$(document).ready(function () {
  $('#sidebar .sidebar-inner').slimScroll({
    height: '100%',
    size: '5px', // Smaller scrollbar width
    color: '#bbb', // Lighter scrollbar color
    opacity: 0.4, // Slightly more transparent
    alwaysVisible: !1,
    disableFadeOut: !1,
    railColor: "#333",
    railOpacity: .2,
    railDraggable: !0,
    allowPageScroll: !1,
    wheelStep: 20,
    railBorderRadius: "7px",
    touchScrollStep: 200,
    railVisible: true, // Show rail
    railColor: '#f8f9fa', // Lighter rail color
    railBorderRadius: "7px"
  });
});
