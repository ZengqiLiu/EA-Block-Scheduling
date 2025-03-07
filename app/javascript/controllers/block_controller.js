// app/javascript/controllers/block_controller.js
document.addEventListener("DOMContentLoaded", () => {
    const selectBlockLink = document.getElementById('select-block-link');
    if (selectBlockLink) {
      selectBlockLink.addEventListener('click', function(event) {
        event.preventDefault(); // prevent navigation
        // Show the modal by modifying the display properties
        document.getElementById('modal').style.display = 'block';
        document.getElementById('modal-overlay').style.display = 'block';
      });
    }
});
  