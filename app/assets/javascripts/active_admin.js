//= require arctic_admin/base
//= require active_admin/base

document.addEventListener('DOMContentLoaded', function() {
  console.log("Inside")
  
  const menuToggle = document.querySelector('#utility_nav a.menu_toggle');
  const sidebar = document.querySelector('#sidebar');
  
  if (menuToggle && sidebar) {
    menuToggle.addEventListener('click', function(e) {
      e.preventDefault();
      sidebar.classList.toggle('open');
      document.body.classList.toggle('sidebar_open');
    });
  }
});