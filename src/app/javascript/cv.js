function disableFinishDate(checkbox) {
  const form = checkbox.closest('form');
  const finishDateField = form.querySelector('input[name$="[finished_at]"]');
  finishDateField.disabled = checkbox.checked;
}

function handleFormSubmission(form) {
  $(form).on('ajax:complete', function(event, xhr, status, error) {
    var response = xhr.responseJSON;
    var messageContainer = $('<div>').addClass('message-container');
    
    if (response) {
      if (xhr.status === 200) {
        var message = response.message;
        messageContainer.text(message);
        messageContainer.addClass('success-message');

        if (response.redirect_to) {
          // Redirect to the specified path
          window.location.href = response.redirect_to;
        }
      } else {
        var errorMessage = response.message || 'Something went wrong!';
        messageContainer.text(errorMessage);
        messageContainer.addClass('error-message');
      }
    } else {
      messageContainer.text('Something went wrong!'); // Handle non-JSON responses
      messageContainer.addClass('error-message');
    }

    $('.message-container').remove();
    $(form).after(messageContainer);
  });
}


function hideFormClass(button) {
  var formClass = button.closest('.form-class');
  if (formClass.style.display == 'none')
    formClass.style.display = 'block';
  else{
  formClass.style.display = 'none';

  var messageContainer = document.createElement('div');
  messageContainer.classList.add('message-container');
  messageContainer.classList.add('success-message');
  messageContainer.textContent = 'Deleted successfully';

  formClass.parentNode.insertBefore(messageContainer, formClass);
  }
}

//used to display save button only after uploading picture
function displaySaveButton(button) {
  var saveButton = document.querySelector('.picture-submit-button');
  saveButton.style.display = "block";
}

//used to refresh the image to default on picture deletion
function hideImageClass(button) {
  var imageClass = button.closest('.image-class');
  imageClass.style.display = 'none';

  var image = document.createElement('img');
  image.src = "https://www.computerhope.com/jargon/g/guest-user.png";
  image.width = 150;
  image.height = 150;
  
  var messageContainer = document.createElement('div');
  messageContainer.classList.add('message-container');
  messageContainer.classList.add('success-message');
  messageContainer.textContent = 'Deleted successfully';

  imageClass.parentNode.insertBefore(image, imageClass);
  imageClass.parentNode.insertBefore(messageContainer, imageClass);
}

