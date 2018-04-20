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

function zoomIn(instance) {
  var camera = instance.camera;
  sigma.misc.animation.camera(camera, {
  ratio: camera.ratio / camera.settings('zoomingRatio')
    }, {
    duration: 200
  });
}

function zoomOut(instance) {
  var camera = instance.camera;
  // Zoom out - animation :
  sigma.misc.animation.camera(camera, {
    ratio: camera.ratio * camera.settings('zoomingRatio')
  }, {
    duration: 200
  });
}

$(document).on('turbolinks:load', function () {
  var so = new sigma({renderers: [
    {
      container: document.getElementById("graph"),
      type: 'canvas' // sigma.renderers.canvas works as well
    }]}); // eslint-disable-line new-cap
  var gm = new sigma({renderers: [
    {
      container: document.getElementById("graph-modal"),
      type: "canvas"
    }
  ]});
  graphRender(so);

  // resize graph-modal if the window changes
  $(window).on('resize', function () {
    $("div#graph-modal").height($(window).height() * 0.75);
  })

  $(".zoom-in").on('click', function (clicked) {
    if (clicked.target.parentNode.id === "modal-zoom-in") {
      zoomIn(gm);
    } else {
      zoomIn(so);
    }
  });

  $(".zoom-out").on('click', function (clicked) {
    if (clicked.target.parentNode.id === "modal-zoom-out") {
      zoomOut(gm);
    } else {
      zoomOut(so);
    }
  });

  // display sigma when modal is launched.
  $('body').on('shown.bs.modal', function (e) {
    $("div#graph-modal").height($(window).height() * 0.75);
    var id = $("div#graph-modal").data('gexf');
    createGraph(id, gm);
  });

  //remove sigma on hidden modal
  $("body").on("hidden.bs.modal", function(){
    $("div#graph-modal canvas").html("");
});
});
