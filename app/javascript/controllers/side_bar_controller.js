const SideBarController = () => {
    // Storing into the localStorage for the side-bar nav active item
    document.addEventListener("DOMContentLoaded", function() {

      const sidebarNav = document.getElementById("sidebar-nav");
      const navLinks = sidebarNav.querySelectorAll(".nav-link");
      
      // Get the active link from localStorage
      const activeNavItem = localStorage.getItem("activeNavItem");
      if (activeNavItem) {
        const activeLink = sidebarNav.querySelector(`[data-bs-target="${activeNavItem}"]`);
        if (activeLink) {
          activeLink.classList.add("show");
        }
      }
      for (const navLink of navLinks) {
        navLink.addEventListener("click", function(event) {
          const target = navLink.getAttribute("data-bs-target");
          const isActive = navLink.classList.contains("show");
          // Hide other collapsed elements except for the current one
          const otherCollapsed = sidebarNav.querySelectorAll(".nav-link[data-bs-toggle='collapse']:not([data-bs-target='" + target + "'])");
          for (const collapsed of otherCollapsed) {
            collapsed.classList.remove("show");
          }
          
          // Toggle the current collapsed element
          if (!isActive) {
            navLink.classList.add("show");
          }
          
          // Store active link target in localStorage
          localStorage.setItem("activeNavItem", target);
        });
      }
    });
  
    // Storing into the localStorage for the nav active item
    $(".nav-child").on('click', function(event) {
      $(".sidebar-nav .nav-link, .sidebar-nav .nav-content a").removeClass("active");
      // Set "active" class on the clicked element
      $(this).addClass("active");
    
      const parentNav = $(this).closest(".nav-content").prev(".nav-link");
      if (parentNav.length > 0) {
        parentNav.addClass("active");
    
        // Hide other collapsed elements except for the parent's
        $(".nav-content.collapse").not(parentNav.attr("data-bs-target")).removeClass("show");
        $(parentNav.attr("data-bs-target")).addClass("show");
      }
    
      activeNav2 = $(this).text();
      localStorage.setItem("activeNav2", activeNav2);
    });
  
    // Retrieve the active element from localStorage and set "active" class on page load
    activeNav2 = localStorage.getItem("activeNav2");
    if (activeNav2) {
      $(".sidebar-nav .nav-content .nav-child").removeClass("active"); // Remove all active classes
      $(".sidebar-nav .nav-child:contains('" + activeNav2 + "')").addClass("active"); // Set active class to the specific element based on its text content
  
      // Set "active" class on the parent element
      const parentNav = $(".sidebar-nav .nav-content .nav-child.active").closest(".nav-content").prev(".nav-link");
      if (parentNav.length > 0) {
        parentNav.addClass("active");
    
        $(".nav-content.collapse").not(parentNav.attr("data-bs-target")).removeClass("show");
        $(parentNav.attr("data-bs-target")).addClass("show");
      }
    }
  }
  export { SideBarController };
  