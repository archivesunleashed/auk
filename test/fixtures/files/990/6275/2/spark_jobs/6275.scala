
      import io.archivesunleashed._
      import io.archivesunleashed.app._
      import io.archivesunleashed.matchbox._
      sc.setLogLevel("INFO")
      RecordLoader.loadArchives("/home/nruest/Projects/tmp/990/6275/warcs/*.gz", sc).keepValidPages().map(r => ExtractDomain(r.getUrl)).countItems().saveAsTextFile("/home/nruest/Projects/tmp/990/6275/1/derivatives/all-domains/output")
      RecordLoader.loadArchives("/home/nruest/Projects/tmp/990/6275/warcs/*.gz", sc).keepValidPages().map(r => (r.getCrawlDate, r.getDomain, r.getUrl, RemoveHTML(RemoveHttpHeader(r.getContentString)))).saveAsTextFile("/home/nruest/Projects/tmp/990/6275/1/derivatives/all-text/output")
      val links = RecordLoader.loadArchives("/home/nruest/Projects/tmp/990/6275/warcs/*.gz", sc).keepValidPages().map(r => (r.getCrawlDate, ExtractLinks(r.getUrl, r.getContentString))).flatMap(r => r._2.map(f => (r._1, ExtractDomain(f._1).replaceAll("^\\s*www\\.", ""), ExtractDomain(f._2).replaceAll("^\\s*www\\.", "")))).filter(r => r._2 != "" && r._3 != "").countItems().filter(r => r._2 > 5)
      WriteGraphML(links, "/home/nruest/Projects/tmp/990/6275/1/derivatives/gephi/6275-gephi.graphml")
      sys.exit
      