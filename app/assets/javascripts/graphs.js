var title = 'cpp2';
console.log(title);

var s = new sigma(title +'degree');
var s2 = new sigma(title +'between');
var s3 = new sigma(title +'eigen');
var s4 = new sigma(title +'authority');
var so = new sigma(title);
sigma.parsers.gexf(
  'GEXF/' + title+ '.gexf',
  so,
  function(y) {
  so.refresh();
  }
);
sigma.parsers.gexf(
    'GEXF/'+title+'25Degree.gexf',
    s,
    function(y) {
    s.refresh();
    }
  );

sigma.parsers.gexf(
      'GEXF/'+title+'25Betweenness.gexf',
      s2,
      function(y) {
      s2.refresh();
      }
    );

sigma.parsers.gexf(
        'GEXF/'+title+'25Eigenvector.gexf',
        s3,
        function(y) {
        s3.refresh();
        }
      );

sigma.parsers.gexf(
          'GEXF/'+title+'25Authority.gexf',
          s4,
          function(y) {
          s4.refresh();
          }
        );

  // Refresh the graph to see the changes:
