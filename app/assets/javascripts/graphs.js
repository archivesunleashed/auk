$(document).on('turbolinks:load', function() {
  if (typeof $("#graph").data("gexf") != 'undefined') {
    var gexfFileData = $("#graph").data("gexf");
    create_graph(gexfFileData);
  }
});

function create_graph(data) {
  var so = new sigma("graph");;
  if (data != ``) {
    data = $.parseXML(data);
    sigma.parsers.gexf(
      data,
      so,
    function(y) {
      so.settings({
        nodeColor: 'default',
        edgeColor: 'default',
        labelThreshold: 6,
      });
      if (so.graph.nodes().length == 0) {
        so.graph.addNode({id: "empty",
                          label: "(This graph is empty.)",
                          x: 10,
                          y: 10,
                          size: 10,
                          color: '#999'});
      }
    }
  );
  so.refresh();
} else {
  $("#graph").append("Cannot find Gexf file");
}}
