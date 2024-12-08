function updateButtonText(button) {
  if (button.innerText === 'Take Admin Rights') {
    button.innerText = 'Give Admin Rights';
  } else if (button.innerText === 'Give Admin Rights') {
    button.innerText = 'Take Admin Rights';
  } else if (button.innerText === 'Block User') {
    button.innerText = 'Unblock User';
  } else if (button.innerText === 'Unblock User') {
    button.innerText = 'Block User';
  }
}

