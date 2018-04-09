function createGraph(data) {
  var so = new sigma('graph'); // eslint-disable-line new-cap
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
    so.refresh();
  } else {
    $('#graph').append('Cannot find Gexf file');
  }
}

$(document).on('turbolinks:load', function () {
  if (typeof $('#graph').data('gexf') !== 'undefined') {
    var gexfFileData = $('#graph').data('gexf'); // eslint-disable-line vars-on-top
    createGraph(gexfFileData);
  }
});
