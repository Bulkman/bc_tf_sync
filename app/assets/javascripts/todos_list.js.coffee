$ ->
  $('input[type=checkbox]').click ->
    # If checked
    if $(this).is(':checked')
        $('#upload_build_release_notes').val($('#upload_build_release_notes').val() + '-' + $(this).val() + '\n')
    else
        text = $('#upload_build_release_notes').val()
        text = text.replace(new RegExp('-' + $(this).val() + '\n','g'), "")
        $('#upload_build_release_notes').val(text)