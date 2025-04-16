// app/javascript/controllers/blocks_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const selectBlockButton = document.getElementById('select-block-button')
    const checkboxes = document.querySelectorAll('.block input[type="checkbox"]')
    const modalOverlay = document.getElementById('modal-overlay')
    const modal = document.getElementById('modal')
    const modalMessage = document.getElementById('modal-message');
    const modalBlockContent = document.getElementById('modal-block-content')
    const modalSelectAgain = document.getElementById('modal-select-again')
    const maxSelectedBlocks = 1

    const disableMoreSelections = () => {
      let selectedCount = 0
      checkboxes.forEach(checkbox => {
        if (checkbox.checked) { selectedCount++ }
      })

      checkboxes.forEach(checkbox => {
        const currentBlock = checkbox.closest('.block')
        if (selectedCount >= maxSelectedBlocks && !checkbox.checked) {
          currentBlock.classList.add('disabled')
          checkbox.disabled = true
        } else {
          currentBlock.classList.remove('disabled')
          checkbox.disabled = false
        }
      })

      if (selectedCount === 0) {
        selectBlockButton.classList.add('disabled')
        selectBlockButton.style.backgroundColor = 'gray';
        selectBlockButton.style.cursor = 'not-allowed';
        selectBlockButton.title = 'Please select a block'
      } else {
        selectBlockButton.classList.remove('disabled')
        selectBlockButton.style.backgroundColor = '';
        selectBlockButton.style.cursor = '';
        selectBlockButton.title = ''
      }
    }

    checkboxes.forEach(checkbox => {
      checkbox.addEventListener('change', disableMoreSelections)
    })
    disableMoreSelections()

    selectBlockButton.addEventListener('click', (event) => {
      event.preventDefault();
      const selectedIds = [];
      checkboxes.forEach(checkbox => {
        if (checkbox.checked) {
          selectedIds.push(checkbox.value);
        }
      });
    
      if (selectedIds.length === 0) {
        alert('No block was selected. Please select a block.')
        return
      } else if (selectedIds.length > 1) {
        alert('Please only select one block.')
        return
      }

      const form = document.getElementById('block-selection-form')
      const formData = new FormData(form)

      const token = document.querySelector('meta[name="csrf-token"]').content

      fetch(form.action, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': token,
          'Accept': 'application/json'
        },
        body: formData
      })
      .then(response => {
        if (!response.ok) { throw new Error("Network response was not ok") }
        return response.json()
      })
      .then(data => {
        modalMessage.innerHTML = data.message
        modalBlockContent.innerHTML = ""
        const selectedBlock = document.querySelector('.block input[type="checkbox"]:checked').closest('.block')
        if (selectedBlock) {
          const clone = selectedBlock.cloneNode(true)
          modalBlockContent.appendChild(clone)
        }
        modal.style.display = 'block'
        modalOverlay.style.display = 'block'
      })
      .catch(error => {
        console.error("Error submitting block selection:", error)
        alert("There was an error submitting your selection. Please try again.")
      })
    })

    modalSelectAgain.addEventListener('click', () => {
      modal.style.display = 'none'
      modalOverlay.style.display = 'none'
    })
  }
}
