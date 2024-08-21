
/**
 * This script handles the toggling of a sidebar menu and adjusts the header position accordingly.
 * 
 * When the DOM content is fully loaded, the following actions are performed:
 * - The sidebar and header elements are selected.
 * - An event listener is added to the toggle menu button to toggle the sidebar's open and closed states.
 * - The header's left position is adjusted based on the sidebar's state.
 * - The sidebar is initially set to the open state, and the header's left position is set accordingly.
 * - A click event is triggered on the active submenu item in the sidebar menu.
 */
document.addEventListener('DOMContentLoaded', function () {
  var toggleMenuButton = document.getElementById('toggle_menu_slidder');
  var sidebar = document.getElementById('sidebar');
  var header = document.querySelector('.header');

  toggleMenuButton.addEventListener('click', function () {
    sidebar.classList.toggle('open');
    sidebar.classList.toggle('closed');

    // Adjust header position based on sidebar state
    if (sidebar.classList.contains('open')) {
      header.style.left = '285px'; // Position when sidebar is open
    } else {
      header.style.left = '195px'; // Position when sidebar is closed
    }
  });

  // Initial state (assuming you want the sidebar open initially)
  sidebar.classList.add('open');
  header.style.left = '285px'; // Initial position when sidebar is open

  // Trigger click on active submenu
  $('#sidebar-menu ul li.submenu a.active').parents('li:last').children('a:first').addClass('active').trigger('click');
});

/**
 * Adds a shadow to the header when the user scrolls down the page.
 *
 * This script listens for the 'DOMContentLoaded' event to ensure the DOM is fully loaded before executing.
 * It then selects the element with the class 'header'.
 * An event listener for the 'scroll' event is added to the window, which checks the vertical scroll position.
 * If the scroll position is greater than 0, it adds the 'header-shadow' class to the header element.
 * If the scroll position is 0, it removes the 'header-shadow' class from the header element.
 */
document.addEventListener('DOMContentLoaded', function () {
  const header = document.querySelector('.header');

  window.addEventListener('scroll', function () {
    if (window.scrollY > 0) {
      header.classList.add('header-shadow');
    } else {
      header.classList.remove('header-shadow');
    }
  });
});