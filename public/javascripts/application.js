(function($){
  $(document).ready(function(){

    $("input.partner").autocomplete({
        minLength: 2,
        source: "/auto.js",
        select: select_player
    })
    .each(function() {
        $(this).data( "autocomplete" )._renderItem = player_formatter;
        handle_default_blur(this);
    });
  });
})(jQuery);

function select_player( event, ui) {
    event.target.value=player_desc(ui.item.player);
    ser_id=event.target.id+"_id"
    $("#"+ser_id).val(ui.item.player.id)
    return false;
}

function player_formatter( ul, item ) {
    return $( "<li></li>" )
        .data( "item.autocomplete", item )
        .append( "<a>" + player_desc(item.player) + "</a>")
        .appendTo( ul );
}

function player_desc(player) {
    if (player.woman_ranking != null) {
        ranking = " (" + player.ranking + "/" + player.woman_ranking + ")"
    } else {
        ranking = " (" + player.ranking + ")"
    }
    return player.name + " " + player.first_name + "; " + player.club + ranking
}

function handle_default_focus(text_field) {
    if (text_field.value==text_field.getAttribute("data-default")) {
        text_field.value=''
        text_field.style.color='black'
    }
}

function partner_blur(text_field) {
    if (text_field.value=='') {
        ser_id=text_field.id+"_id";
        $("#"+ser_id).val('');
    }
    handle_default_blur(text_field);
}

function handle_default_blur(text_field) {
    if (text_field.value=='') {
        text_field.value=text_field.getAttribute("data-default")
        text_field.style.color='gray'
    }
}

function sel_item(theUrl) {document.location.href = theUrl;}