function createGraph(data, instance) {
  if (data !== '') {
    data = $.parseXML(data); // eslint-disable-line no-param-reassign
    sigma.parsers.gexf(data, instance, function (y) { // eslint-disable-line no-unused-vars
      instance.settings({
        nodeColor: 'default',
        edgeColor: 'default',
<<<<<<< HEAD
        defaultEdgeType: 'arrow',
        labelThreshold: 7,
        minNodeSize: 3,
        minArrowSize: 5
      });
      // We first need to save the original colors of our
      // nodes and edges, like this:
      instance.graph.nodes().forEach(function (n) {
        n.originalColor = n.color;
      });
      instance.graph.edges().forEach(function (e) {
        e.originalColor = e.color;
=======
        labelThreshold: 7,
        minNodeSize: 3
>>>>>>> master
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
  if (typeof $('#graph-modal').data('gexf') !== 'undefined') {
    var gexfFileData = $('#graph-modal').data('gexf'); // eslint-disable-line vars-on-top
    createGraph(gexfFileData, instance);
  }
}

function increment(state) {
  return state + 1;
}

function decrement(state) {
  if (state <= 1) {
    return 0;
  }
  return state - 1;
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

function scaleUp(instance) {
  var nodes = instance.graph.nodes();
  nodes.forEach(x => {
    if (isFinite(Math.log(x.size + 2))) {
      x.size = Math.log(x.size + 2);
    } else {
      x.size = x.size;
    }
  });
  instance.refresh();
}

function scaleDown(instance) {
  var nodes = instance.graph.nodes();
  nodes.forEach(x => {
    if (isFinite(Math.exp(x.size) - 2)) {
      x.size = Math.exp(x.size) - 2;
    } else if (Math.exp(x.size) - 2 < 1) {
      x.size = 1;
    } else {
      x.size = x.size;
    }
  });
  instance.refresh();
}

function refresh(instance) {
  var camera = instance.camera;
  sigma.misc.animation.camera(camera, {
    ratio: 1,
    x: 0,
    y: 0
  }, {
    duration: 200
  });
  graphRender(instance);
}

function goFullScreen() {
  var elem = document.documentElement;
  if (elem.requestFullscreen) {
    elem.requestFullscreen();
  } else if (elem.msRequestFullscreen) {
    elem.msRequestFullscreen();
  } else if (elem.mozRequestFullScreen) {
    elem.mozRequestFullScreen();
  } else if (elem.webkitRequestFullscreen) {
    elem.webkitRequestFullscreen();
  }
}

function leaveFullScreen() {
  if (document.exitFullscreen) {
    document.exitFullscreen();
  } else if (document.webkitExitFullscreen) {
    document.webkitExitFullscreen();
  } else if (document.mozCancelFullScreen) {
    document.mozCancelFullScreen();
  } else if (document.msExitFullscreen) {
    document.msExitFullscreen();
  }
}

$(document).on('turbolinks:load', function () {
  var state = 0;
<<<<<<< HEAD
  var so;
  var gm;
  if (sigma && !sigma.classes.graph.hasMethod('neighbors')) {
    // create neighbors method to access neighbors of a node.
    sigma.classes.graph.addMethod('neighbors', function (nodeId) {
      var neighbors = {};
      var index = this.allNeighborsIndex[nodeId] || {};
      var here = this;
      Object.keys(index).forEach(function (key) {
        neighbors[key] = here.nodesIndex[key];
      });
      return neighbors;
    });
  }
  so = new sigma({ renderers: [ // eslint-disable-line new-cap
=======
  var so = new sigma({ renderers: [ // eslint-disable-line new-cap
>>>>>>> master
    {
      container: document.getElementById('graph'),
      type: 'canvas' // sigma.renderers.canvas works as well
    }]
  });
  gm = new sigma({ renderers: [ // eslint-disable-line new-cap
    {
      container: document.getElementById('graph-modal'),
      type: 'canvas'
    }]
  });
<<<<<<< HEAD
=======
  graphRender(so);
  graphRender(gm);
>>>>>>> master

  graphRender(so);
  graphRender(gm);
  // resize graph-modal if the window changes
  $(window).on('resize', function () {
    $('div#graph-modal').height($(window).height() * 0.83);
  });

<<<<<<< HEAD
  so.bind('overNode', function (node) {
    var nodeId = node.data.node.id;
    var toKeep = so.graph.neighbors(nodeId);
    toKeep[nodeId] = node.data.node;
    so.graph.nodes().forEach(function (n) {
      if (toKeep[n.id]) {
        n.color = n.originalColor;
      } else {
        n.color = '#eee';
      }
    });
    so.graph.edges().forEach(function (e) {
      if (toKeep[e.source] && toKeep[e.target]) {
        e.color = e.originalColor;
      } else {
        e.color = '#eee';
      }
    });
    so.refresh();
  });

  gm.bind('overNode', function (node) {
    var nodeId = node.data.node.id;
    var toKeep = gm.graph.neighbors(nodeId);
    toKeep[nodeId] = node.data.node;
    gm.graph.nodes().forEach(function (n) {
      if (toKeep[n.id]) {
        n.color = n.originalColor;
      } else {
        n.color = '#eee';
      }
    });
    gm.graph.edges().forEach(function (e) {
      if (toKeep[e.source] && toKeep[e.target]) {
        e.color = e.originalColor;
      } else {
        e.color = '#eee';
      }
    });
    gm.refresh();
  });

  so.bind('outNodes', function () {
    so.graph.nodes().forEach(function (n) {
      n.color = n.originalColor;
    });
    so.graph.edges().forEach(function (e) {
      e.color = e.originalColor;
    });
    so.refresh();
  });

  gm.bind('outNodes', function () {
    gm.graph.nodes().forEach(function (n) {
      n.color = n.originalColor;
    });
    gm.graph.edges().forEach(function (e) {
      e.color = e.originalColor;
    });
    gm.refresh();
  });

  $('.zoom-in').on('click', function () {
    zoomIn(gm);
    zoomIn(so);
  });

  $('.zoom-out').on('click', function () {
    zoomOut(gm);
    zoomOut(so);
  });

  $('.default').on('click', function () {
    refresh(gm);
    refresh(so);
    $('.scale-down').prop('disabled', true);
    state = 0;
  });

=======
  $('.zoom-in').on('click', function () {
    zoomIn(gm);
    zoomIn(so);
  });

  $('.zoom-out').on('click', function () {
    zoomOut(gm);
    zoomOut(so);
  });

  $('.default').on('click', function () {
    refresh(gm);
    refresh(so);
    $('.scale-down').prop('disabled', true);
    state = 0;
  });

>>>>>>> master
  $('.scale-up').on('click', function () {
    state = increment(state);
    increment(state);
    $('.scale-down').prop('disabled', false);
    scaleUp(gm);
    scaleUp(so);
  });

  $('.scale-down').on('click', function () {
    if (state >= 1) {
      state = decrement(state);
      scaleDown(gm);
      scaleDown(so);
      if (state === 0) {
        $('.scale-down').prop('disabled', true);
      }
    } else {
      $('.scale-down').prop('disabled', true);
    }
  });

  $('span#modal-click').on('click', function () {
    goFullScreen();
  });

  $('button#modal-exit-fullscreen').on('click', function () {
    leaveFullScreen();
  });

  // display sigma when modal is launched.
  $('body').on('shown.bs.modal', function () {
    gm.renderers[0].resize();
    gm.refresh();
  });

  // remove sigma on hidden modal.
  $('body').on('hidden.bs.modal', function () {
    $('div#graph-modal canvas').html('');
  });
});
