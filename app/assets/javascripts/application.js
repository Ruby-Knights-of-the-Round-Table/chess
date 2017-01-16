// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs

//= require_tree .

//= require jquery-ui

function moveLog(pieceID) {
    $(function () {
      // console.log(pieceID)
      $.get( '/moves/' + pieceID.toString()).success (function(infomation)  {
      // console.log(infomation)
      var div = document.getElementById("log");
      div.innerHTML = "<p> Moves List: </p>"
      for( var i = 0; i < infomation.length; i++){
        currentMove = infomation[i]
        if( parseInt(currentMove[1]) == 0 ){
            continue
        }
        else{
            if (currentMove[1] % 2 == 1){
                div.innerHTML += "<p> Turn " + currentMove[1]+  ": White " + currentMove[0] + " to y: " + currentMove[3] + ", x: " + currentMove[4] +"</p>";
            }
            else{
                div.innerHTML += "<p> Turn " + currentMove[1]+  ": Black " + currentMove[0] + " to y: " + currentMove[3] + ", x: " + currentMove[4] +"</p>";
            }

        }


      }

      })


    })

}
