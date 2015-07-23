$('#show-user-form').click(function() { $('#user-form').toggle(); });

function success() { alert('Successfully updated!'); }
function error() { alert('Something went wrong :('); }
function submit(errors, values) {
  errors ? error() : $.post('/data', JSON.stringify(values)).done(success).fail(error);
}