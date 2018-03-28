$(document).ready(function() {
  if (typeof $("#graph").data("gexf") != 'undefined') {
    var gexfFileData = $("#graph").data("gexf");
    create_graph(gexfFileData);
  }
});

function create_graph(data) {
  if (data != ``) {
    data = $.parseXML(data);
    var so = new sigma("graph");
    sigma.parsers.gexf(
      data,
      so,
    function(y) {
      so.settings({
        nodeColor: 'default',
        edgeColor: 'default',
        labelThreshold: 4,
      })
      so.refresh()
    }
  );
} else {
  $("#graph").append("Cannot find Gexf file");
}}
