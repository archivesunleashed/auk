function createGraph(data, instance) {
  if (data !== '') {
    data = $.parseXML(data); // eslint-disable-line no-param-reassign
    sigma.parsers.gexf(data, instance, function (y) { // eslint-disable-line no-unused-vars
      instance.settings({
        nodeColor: 'default',
        edgeColor: 'default',
        labelThreshold: 7,
        minNodeSize: 3
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
  var max = Math.max(...nodes.map(x => x.size));
  nodes.forEach(x => {
    if (isFinite(x.size) && Math.pow(x.size, 2) < max) {
      x.size = Math.pow(x.size + 1, 2);
    } else if (Math.pow(x.size + 1, 2) >= max) {
      x.size = max;
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
  var so = new sigma({ renderers: [ // eslint-disable-line new-cap
    {
      container: document.getElementById('graph'),
      type: 'canvas' // sigma.renderers.canvas works as well
    }]
  });
  var gm = new sigma({ renderers: [ // eslint-disable-line new-cap
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
  });

  $('.scale-up').on('click', function () {
    scaleUp(gm);
    scaleUp(so);
  });

  $('button#modal-click').on('click', function () {
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
