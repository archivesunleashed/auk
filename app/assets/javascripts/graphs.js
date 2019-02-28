function createGraph(data, instance) {
  sigma.parsers.gexf(data, instance, function (y) { // eslint-disable-line no-unused-vars
    instance.settings({
      nodeColor: 'default',
      edgeColor: 'default',
      defaultEdgeType: 'arrow',
      labelThreshold: 7,
      minNodeSize: 1,
      minArrowSize: 5
    });
    instance.graph.nodes().forEach(function (n) {
      n.originalColor = n.color;
    });
    instance.graph.edges().forEach(function (e) {
      e.originalColor = e.color;
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
    instance.renderers[0].resize();
    instance.refresh();
  });
}

function graphRender(instance) {
  var gexfUrl = $('#graph-modal').data('gexf_url');
  createGraph(gexfUrl, instance);
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
    if (isFinite(Math.log(x.size + 2))) { // eslint-disable-line no-restricted-globals
      x.size = Math.log(x.size + 2);
    } else {
      x.size = x.size; // eslint-disable-line no-self-assign
    }
  });
  instance.refresh();
}

function scaleDown(instance) {
  var nodes = instance.graph.nodes();
  nodes.forEach(x => {
    if (isFinite(Math.exp(x.size) - 2)) { // eslint-disable-line no-restricted-globals
      x.size = Math.exp(x.size) - 2;
    } else if (Math.exp(x.size) - 2 < 1) {
      x.size = 1;
    } else {
      x.size = x.size; // eslint-disable-line no-self-assign
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
  so = new sigma({ // eslint-disable-line new-cap
    renderers: [
      {
        container: document.getElementById('graph'),
        type: 'canvas' // sigma.renderers.canvas works as well
      }]
  });
  gm = new sigma({ // eslint-disable-line new-cap
    renderers: [
      {
        container: document.getElementById('graph-modal'),
        type: 'canvas'
      }]
  });

  graphRender(so);
  graphRender(gm);
  // resize graph-modal if the window changes
  $(window).on('resize', function () {
    $('div#graph-modal').height($(window).height() * 0.83);
  });

  so.bind('overNode', function (node) {
    var nodeId = node.data.node.id;
    var toKeep = so.graph.neighbors(nodeId);
    toKeep[nodeId] = node.data.node;
    so.graph.nodes().forEach(function (n) {
      if (toKeep[n.id]) {
        n.color = n.originalColor;
      } else {
        n.color = 'rgba(200, 200, 200, 0.75)';
      }
    });
    so.graph.edges().forEach(function (e) {
      if (toKeep[e.source] && toKeep[e.target]) {
        e.color = e.originalColor;
      } else {
        e.color = 'rgba(200, 200, 200, 0.75)';
      }
    });
    setTimeout(function () {
      so.refresh();
    }, 200);
  });

  gm.bind('overNode', function (node) {
    var nodeId = node.data.node.id;
    var toKeep = gm.graph.neighbors(nodeId);
    toKeep[nodeId] = node.data.node;
    gm.graph.nodes().forEach(function (n) {
      if (toKeep[n.id]) {
        n.color = n.originalColor;
      } else {
        n.color = 'rgba(200, 200, 200, 0.75)';
      }
    });
    gm.graph.edges().forEach(function (e) {
      if (toKeep[e.source] && toKeep[e.target]) {
        e.color = e.originalColor;
      } else {
        e.color = 'rgba(200, 200, 200, 0.75)';
      }
    });
    setTimeout(function () {
      gm.refresh();
    }, 200);
  });

  so.bind('outNodes', function () {
    so.graph.nodes().forEach(function (n) {
      n.color = n.originalColor;
    });
    so.graph.edges().forEach(function (e) {
      e.color = e.originalColor;
    });
    setTimeout(function () {
      so.refresh();
    }, 200);
  });

  gm.bind('outNodes', function () {
    gm.graph.nodes().forEach(function (n) {
      n.color = n.originalColor;
    });
    gm.graph.edges().forEach(function (e) {
      e.color = e.originalColor;
    });
    setTimeout(function () {
      gm.refresh();
    }, 2000);
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

  $('#image-link').on('click', function () {
    var button = document.getElementById('image-link');
    var canvas = $('.sigma-scene');
    var camera = so.camera;
    var fn = button.getAttribute('download').replace('-image.png', '');
    var img = canvas[1].toDataURL('image/png');
    button.setAttribute('download', fn + 'xyr-' + Math.abs(Math.round(camera.x))
      + '-' + Math.abs(Math.round(camera.y)) + '-' + Math.abs(Math.round(camera.ratio))
      + '-image.png');
    button.href = img;
  });

  $('#modal-image-link').on('click', function () {
    var button = document.getElementById('modal-image-link');
    var canvas = $('.sigma-scene');
    var camera = gm.camera;
    var fn = button.getAttribute('download').replace('-image.png', '');
    var img = canvas[0].toDataURL('image/png');
    button.setAttribute('download', fn + 'xyr-' + Math.abs(Math.round(camera.x))
      + '-' + Math.abs(Math.round(camera.y)) + '-' + Math.abs(Math.round(camera.ratio))
      + '-image.png');
    button.href = img;
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
