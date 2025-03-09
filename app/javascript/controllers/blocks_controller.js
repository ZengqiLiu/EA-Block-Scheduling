// app/javascript/controllers/blocks_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const selectBlockButton = document.getElementById('select-block-button')
    const checkboxes = document.querySelectorAll('.block input[type="checkbox"]')
    const modalOverlay = document.getElementById('modal-overlay')
    const modal = document.getElementById('modal')
    const modalMessage = document.getElementById('modal-message')
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
      event.preventDefault()
      const selectedBlocks = []
      checkboxes.forEach(checkbox => {
        if (checkbox.checked) { selectedBlocks.push(checkbox.value) }
      })

      if (selectedBlocks.length > 0) {
        const message = selectedBlocks.length === 1
          ? `You have successfully selected <strong>Block ${selectedBlocks[0]}</strong>.`
          : `You have successfully selected <strong>Blocks ${selectedBlocks.join(', ')}</strong>.`
        modalMessage.innerHTML = message
        modal.style.display = 'block'
        modalOverlay.style.display = 'block'
      }
    })

    modalSelectAgain.addEventListener('click', () => {
      modal.style.display = 'none'
      modalOverlay.style.display = 'none'
    })
  }
}
