function createGraph(data, instance) {
  if (data !== '') {
    data = $.parseXML(data); // eslint-disable-line no-param-reassign
    sigma.parsers.gexf(data, instance, function (y) { // eslint-disable-line no-unused-vars
      instance.settings({
        nodeColor: 'default',
        edgeColor: 'default',
        labelThreshold: 6
      });
      if (instance.graph.nodes().length === 0) {
        instance.graph.addNode({
          id: 'empty',
          label: '(This graph is empty.)',
          x: 10,
          y: 10,
          size: 10,
          color: '#999'
        });
      }
    });
    instance.renderers[0].resize();
    instance.refresh();
  } else {
    $('#graph').append('Cannot find Gexf file');
  }
}

function graphRender(instance) {
  if (typeof $("#graph-modal").data('gexf') !== 'undefined') {
    var gexfFileData = $("#graph-modal").data('gexf') // eslint-disable-line vars-on-top
    createGraph(gexfFileData, instance);
  }
}

$(document).on('turbolinks:load', function () {
  var so = new sigma({renderers: [
    {
      container: document.getElementById("graph"),
      type: 'canvas' // sigma.renderers.canvas works as well
    }]}); // eslint-disable-line new-cap
  graphRender(so);

  // resize graph-modal if the window changes
  $(window).on('resize', function () {
    $("div#graph-modal").height($(window).height() * 0.75);
  })

  $("#zoom-up").on('click', function (clicked) {
    if (clicked.target.parentElement === "div#graph") {
      console.log(clicked.target.parentElement);
    }
  });

  // display sigma when modal is launched.
  $('body').on('shown.bs.modal', function (e) {
    $("div#graph-modal").height($(window).height() * 0.75);
    if(typeof $("#graph-modal canvas" === 'undefined')){
      var id = $("#graph-modal").data('gexf');
      var gm = new sigma({renderers: [
        {
          container: document.getElementById("graph-modal"),
          type: "canvas"
        }
      ]});
      createGraph(id, gm);
      }
  });

  //remove sigma on hidden modal
  $(".modal").on("hidden.bs.modal", function(){
    $("#graph-modal").html("");
});
});
