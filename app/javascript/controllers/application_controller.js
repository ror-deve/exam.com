import * as bootstrap from "bootstrap";
import Croppie from "croppie";
import ClassicEditor from "../ckeditor";

const ApplicationController = () => {
  ClassicEditor;
  // Initiate tooltips and popover
  let popoverTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="popover"]')
  );
  let popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl);
  });

  var tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });

  // Sidebar toggle
  var sidebar_btn = document.querySelector(".toggle-sidebar-btn");
  if (sidebar_btn !== null) {
    sidebar_btn.onclick = function () {
      document.querySelector("body").classList.toggle("toggle-sidebar");
    };
  }

  // Search bar toggle
  var search_bar = document.querySelector(".search-bar-toggle");
  if (search_bar !== null) {
    search_bar.onclick = function () {
      document.querySelector(".search-bar").classList.toggle("search-bar-show");
    };
  }

  // spinner for sidebar
  function showSpinner() {
    var loadingOverlay = document.getElementById("loadingOverlay");
    loadingOverlay.style.display = "flex";
  }

  function hideSpinner() {
    var loadingOverlay = document.getElementById("loadingOverlay");
    loadingOverlay.style.display = "none";
  }

  function handleSidebarLinkClick(event) {
    event.preventDefault(); // Prevent default link behavior
    showSpinner();

    var targetUrl = this.href;

    setTimeout(function() {
      window.location.href = targetUrl;
    }, 500); // Navigate after 2 seconds
  }

  document.addEventListener("DOMContentLoaded", function() {
    var sidebarLinks = document.querySelectorAll("#sidebar-nav a.nav-link, #sidebar-nav a.nav-child");
    sidebarLinks.forEach(function(link) {
      link.addEventListener("click", handleSidebarLinkClick);
    });
  });

  // Initiate Bootstrap validation check
  (function () {
    "use strict";
    var forms = document.querySelectorAll(".needs-validation");
    Array.prototype.slice.call(forms).forEach(function (form) {
      form.addEventListener(
        "submit",
        function (event) {
          if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
          }
          form.classList.add("was-validated");
        },
        false
      );
    });
  })();

  // Easy selector helper function
  const select = (el, all = false) => {
    el = el.trim();
    if (all) {
      return [...document.querySelectorAll(el)];
    } else {
      return document.querySelector(el);
    }
  };

  // Easy event listener function
  const on = (type, el, listener, all = false) => {
    if (all) {
      select(el, all).forEach((e) => e.addEventListener(type, listener));
    } else {
      select(el, all).addEventListener(type, listener);
    }
  };

  // Toggle .header-scrolled class to #header when page is scrolled
  let selectHeader = document.querySelector("#header");
  if (selectHeader) {
    const headerScrolled = () => {
      if (window.scrollY > 100) {
        selectHeader.classList.add("header-scrolled");
      } else {
        selectHeader.classList.remove("header-scrolled");
      }
    };
    window.addEventListener("load", headerScrolled);
    onscroll(document, headerScrolled);
  }

  // Back to top button
  let backtotop = document.querySelector(".back-to-top");
  if (backtotop) {
    const toggleBacktotop = () => {
      if (window.scrollY > 100) {
        backtotop.classList.add("active");
      } else {
        backtotop.classList.remove("active");
      }
    };
    window.addEventListener("load", toggleBacktotop);
    onscroll(document, toggleBacktotop);
  }

  // Easy on scroll event listener
  function onscroll(el, listener) {
    el.addEventListener("scroll", listener);
  }

  // Easy on scroll event listener
  let navbarlinks = document.querySelector(".scrollto");
  const navbarlinksActive = () => {
    let position = window.scrollY + 200;
    if (navbarlinks !== null) {
      navbarlinks.forEach((navbarlink) => {
        if (!navbarlink.hash) return;
        let section = document.querySelector(navbarlink.hash);
        if (!section) return;
        if (
          position >= section.offsetTop &&
          position <= section.offsetTop + section.offsetHeight
        ) {
          navbarlink.classList.add("active");
        } else {
          navbarlink.classList.remove("active");
        }
      });
    }
  };
  window.addEventListener("load", navbarlinksActive);
  onscroll(document, navbarlinksActive);
};


//  Spinner Overlay

async function handleSidebarLinkClick(event) {
  event.preventDefault();
  showSpinner();

  var targetUrl = this.href;

  try {
    let response = await fetch(targetUrl, {
      method: 'GET',
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      }
    });

    if (response.ok) {
      let data = await response.text();
      document.getElementById('content').innerHTML = data;
    } else {
      alert('An error occurred while processing the request.');
    }

    await new Promise(resolve => setTimeout(resolve, 3000));
  } catch (error) {
    console.error('Error:', error);
  } finally {
    hideSpinner();
  }
}
 
//  Notifiation hide text 
document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll('.mark-as-read').forEach(function(link) {
    link.addEventListener('click', function(event) {
      event.preventDefault();
      var markAsReadLink = this;
      var notificationId = markAsReadLink.dataset.notification_id;

      markAsReadLink.nextElementSibling.style.display = 'none';

      Rails.ajax({
        type: 'PATCH',
        url: markAsReadLink.href,
        data: '',
        success: function(response) {
        },
        error: function(response) {
        }
      });
    });
  });
});

// For time tracking
document.addEventListener('DOMContentLoaded', function() {
  const timerElement = document.getElementById('timer');
  let remainingTime = parseInt(timerElement.getAttribute('data-remaining-time'), 10); // Time in seconds

  function formatTime(seconds) {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const sec = seconds % 60;
    return `${('0' + hours).slice(-2)}:${('0' + minutes).slice(-2)}:${('0' + sec).slice(-2)}`;
  }

  function updateTimer() {
    if (remainingTime <= 0) {
      clearInterval(timerInterval);
      timerElement.textContent = '00:00';
      alert('Time is up!');
      document.getElementById('exam-form').submit(); // Automatically submit the form
      return;
    }

    timerElement.textContent = formatTime(remainingTime);
    remainingTime--;
  }

  const timerInterval = setInterval(updateTimer, 1000);
  updateTimer(); // Initial call to set the timer immediately
});

export { ApplicationController };
