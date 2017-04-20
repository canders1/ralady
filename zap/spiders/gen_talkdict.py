import scrapy

class ZapSpider(scrapy.Spider):
    name = "alltalkdict"

    prevID = ""

    def start_requests(self):
        urls = [
            'http://talkingdictionary.swarthmore.edu/' + self.lang + '/?entry=1',
            #'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=1',
            #'http://talkingdictionary.swarthmore.edu/tlacochahuaya/?entry=1',
            #'http://talkingdictionary.swarthmore.edu/teotitlan/?entry=1',
            #'http://talkingdictionary.swarthmore.edu/miahuatec_sbl/?entry=1',
        ]
        for i in urls:
            yield scrapy.Request(i)

    def parse(self, response):
        currentIndex = int(response.url.split("?entry=")[-1])+1
        baseurl = response.url.split("?entry=")[:-1]
        nextp = baseurl[0] + "?entry=" + str(currentIndex)
        currID = ""
        lang = baseurl[0].split("/")[-2]
        for zap in response.css('div.entry'):
            yield{
            'morph': zap.css("h3::text").extract_first(),
            'ipa': zap.css("span.ipa::text").extract_first(),
            'id': zap.css("div span a::attr(href)").extract_first().split("?entry=")[-1],
            'gloss': zap.css("span.gloss::text").extract_first(),
            'sourcepage': response.url[-1:],
            'source': self.lang,
            'prev': self.prevID,
            }
            currID = zap.css("div span a::attr(href)").extract_first().split("?entry=")[-1]



         # follow pagination links
        next_page = nextp
        if (next_page is not None) and (self.prevID != currID):
            self.prevID = currID
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, callback=self.parse)

