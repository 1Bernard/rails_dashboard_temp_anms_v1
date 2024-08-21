function animateButton(button) {
  button.classList.add('animated'); // Add your animation class here
  setTimeout(() => {
    button.classList.remove('animated'); // Remove the animation class after a delay
  }, 300); // Adjust the delay time as needed
}

function loadPaginatedPagesViaAjax(){
   $('.pagination a').attr('data-remote', 'true');
}


document.addEventListener("DOMContentLoaded", function () {
  // Initial sorting order (ascending)
  var sortOrder = 1;

  function sortTable(columnIndex) {
    var table = document.getElementById("sortTable");
    var headerCells = document.querySelectorAll("#sortTable thead th");
    var rows = Array.from(table.rows).slice(1); // Exclude the header row
    var isNumeric = columnIndex === 0 || columnIndex === 4 || columnIndex === 8; // Adjust based on your column types

    // Remove the "sorted" class from all header cells
    headerCells.forEach(function (cell) {
      cell.classList.remove("sorted-asc", "sorted-desc");
    });

    // Add the appropriate "sorted" class to the clicked header cell
    headerCells[columnIndex].classList.add(sortOrder === 1 ? "sorted-asc" : "sorted-desc");

    rows.sort(function (a, b) {
      var aValue = a.cells[columnIndex].textContent.trim();
      var bValue = b.cells[columnIndex].textContent.trim();

      if (!isNumeric) {
        // Case-insensitive alphabetical sort
        aValue = aValue.toLowerCase();
        bValue = bValue.toLowerCase();
      } else {
        // Numeric sort
        aValue = parseFloat(aValue);
        bValue = parseFloat(bValue);
      }

      if (aValue > bValue) {
        return sortOrder;
      } else if (aValue < bValue) {
        return -sortOrder;
      } else {
        return 0;
      }
    });

    // Remove existing rows from the table
    rows.forEach(function (row) {
      table.tBodies[0].removeChild(row);
    });

    // Append sorted rows to the table
    rows.forEach(function (row) {
      table.tBodies[0].appendChild(row);
    });

    // Toggle sorting order for the next click
    sortOrder *= -1;
  }

  // Add click event listeners to the header cells for sorting
  var headerCells = document.querySelectorAll("#sortTable thead th");
  headerCells.forEach(function (cell, index) {
    cell.addEventListener("click", function () {
      sortTable(index);
    });
  });
});

function filterTable(status) {
  var tabs = document.querySelectorAll('.tab');
  var table = document.getElementById("sortTable");
  var headerRow = table.querySelector("thead tr");
  var bodyRows = table.getElementsByTagName("tr");

  // Remove the "active" class from all tabs
  tabs.forEach(function (tab) {
    tab.classList.remove('active');
  });

  // Add the "active" class to the clicked tab
  event.target.classList.add('active');

  var hasMatchingRows = false;

  for (var i = 0; i < bodyRows.length; i++) {
    var processedStatus = bodyRows[i].getAttribute("data-processed");

    var shouldDisplay =
      (status === 'all') ||
      (status === "successful" && processedStatus === "true") ||
      (status === "pending" && !processedStatus) ||
      (status === "failed" && processedStatus === "false");

    bodyRows[i].style.display = shouldDisplay ? "" : "none";

    // Check if there are rows matching the specified status
    if (shouldDisplay) {
      hasMatchingRows = true;
    }
  }

  // Always display the thead, even if there are no matching rows
  headerRow.style.display = "";

}

