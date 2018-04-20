function createGraph(data, container) {
  var so = new sigma({renderers: [
    {
      container: document.getElementById(container),
      type: 'canvas' // sigma.renderers.canvas works as well
    }]}); // eslint-disable-line new-cap
  if (data !== '') {
    data = $.parseXML(data); // eslint-disable-line no-param-reassign
    sigma.parsers.gexf(data, so, function (y) { // eslint-disable-line no-unused-vars
      so.settings({
        nodeColor: 'default',
        edgeColor: 'default',
        labelThreshold: 6
      });
      if (so.graph.nodes().length === 0) {
        so.graph.addNode({
          id: 'empty',
          label: '(This graph is empty.)',
          x: 10,
          y: 10,
          size: 10,
          color: '#999'
        });
      }
    });
    so.renderers[0].resize();
    so.refresh();
  } else {
    $('#'.concat(container)).append('Cannot find Gexf file');
  }
}

function graphRender(container) {
  if (typeof $("#graph-modal").data('gexf') !== 'undefined') {
    var gexfFileData = $("#graph-modal").data('gexf') // eslint-disable-line vars-on-top
    createGraph(gexfFileData, container);
  }
}

$(document).on('turbolinks:load', function () {
  graphRender("graph");
  $(window).on('resize', function () {
    $("div#graph-modal").height($(window).height() * 0.75);
  })

  $('body').on('shown.bs.modal', function (e) {
    if(typeof $("#graph-modal canvas" === 'undefined')){

      id = $("#graph-modal").data('gexf');
      createGraph(id, "graph-modal");
      }
  });
  $(".modal").on("hidden.bs.modal", function(){
    $("#graph-modal").html("");
});
});
