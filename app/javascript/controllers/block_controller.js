// app/javascript/controllers/block_controller.js
document.addEventListener("DOMContentLoaded", () => {
    // Use the updated ID for the SELECT BLOCK button
    const selectBlockButton = document.getElementById('select-block-button');
  
    // Query checkboxes inside .block elements (updated selector)
    const checkboxes = document.querySelectorAll('.block input[type="checkbox"]');
  
    const modalOverlay = document.getElementById('modal-overlay');
    const modal = document.getElementById('modal');
    const modalMessage = document.getElementById('modal-message');
    const modalSelectAgain = document.getElementById('modal-select-again');
    const modalBackToSchedule = document.getElementById('modal-back-to-schedule');
  
    const maxSelectedBlocks = 1;
  
    // Function to update selection state and disable/enable blocks accordingly
    function disableMoreSelections() {
      let selectedCount = 0;
      checkboxes.forEach(checkbox => {
        if (checkbox.checked) {
          selectedCount++;
        }
      });
  
      checkboxes.forEach(checkbox => {
        const currentBlock = checkbox.closest('.block');
        if (selectedCount >= maxSelectedBlocks && !checkbox.checked) {
          currentBlock.classList.add('disabled');
          checkbox.disabled = true;
        } else {
          currentBlock.classList.remove('disabled');
          checkbox.disabled = false;
        }
      });
  
      // Update the SELECT BLOCK button state
      if (selectedCount === 0) {
        selectBlockButton.disabled = true;
        selectBlockButton.style.backgroundColor = 'gray';
        selectBlockButton.style.cursor = 'not-allowed';
        selectBlockButton.title = 'Please select a block';
      } else {
        selectBlockButton.disabled = false;
        selectBlockButton.style.backgroundColor = '#800000';
        selectBlockButton.style.cursor = 'pointer';
        selectBlockButton.title = '';
      }
    }
  
    // Listen for changes on checkboxes to update the UI immediately
    checkboxes.forEach(checkbox => {
      checkbox.addEventListener('change', disableMoreSelections);
    });
    disableMoreSelections(); // Initial call
  
    // When the SELECT BLOCK button is clicked, check which blocks are selected,
    // display a modal with a success message, and prevent default link behavior.
    selectBlockButton.addEventListener('click', (event) => {
      event.preventDefault();
      const selectedBlocks = [];
      checkboxes.forEach(checkbox => {
        if (checkbox.checked) {
          selectedBlocks.push(checkbox.value);
        }
      });
  
      if (selectedBlocks.length > 0) {
        let message;
        if (selectedBlocks.length === 1) {
          message = `You have successfully selected block ${selectedBlocks[0]}.`;
        } else {
          message = `You have successfully selected blocks ${selectedBlocks.join(', ')}.`;
        }
        modalMessage.textContent = message;
        modal.style.display = 'block';
        modalOverlay.style.display = 'block';
      }
    });
  
    // Handlers to hide the modal when necessary
    modalSelectAgain.addEventListener('click', () => {
      modal.style.display = 'none';
      modalOverlay.style.display = 'none';
    });
  
    modalBackToSchedule.addEventListener('click', () => {
      window.location.href = '/schedule_viewer';
    });
  });
  