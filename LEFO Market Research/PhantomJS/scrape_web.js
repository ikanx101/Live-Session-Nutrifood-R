var webPage = require('webpage');
var page = webPage.create();
var fs = require('fs');

var url  = 'https://news.detik.com/berita/d-5340933/visi-presisi-komjen-sigit-calon-kapolri'
var path = 'odds_PaddyPower.html'


page.open(url, function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();
});
