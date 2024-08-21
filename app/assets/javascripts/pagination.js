// This function initializes pagination by setting the 'data-remote' attribute to 'true' for all pagination links.
// This enables AJAX functionality for pagination, allowing the page to be updated without a full reload.
$(function () {
    $('.pagination a').attr('data-remote', 'true');
});
