$(document).ready(function() {
  $('.chosen-select').chosen({
    allow_single_deselect: true,
    max_selected_options: 25,
    placeholder_text_multiple: " ",
    no_results_text: 'No results matched',
    width: '200px'
  });
});
