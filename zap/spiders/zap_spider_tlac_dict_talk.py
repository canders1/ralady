import scrapy


class ZapSpider(scrapy.Spider):
    name = "tlactalkdict"

    start_urls = [
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=1',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=500',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=1000',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=1500',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=2000',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=2500',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=3000',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=4000',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=5000',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=6000',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=7000',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=8000',
            'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=9000',
        ]

    def parse(self, response):
        currentIndex = int(response.url.split("?entry=")[-1])+1
        nextp = 'http://talkingdictionary.swarthmore.edu/tlacolula/?entry=' + str(currentIndex)
        for zap in response.css('div.entry'):
            yield{
            'morph': zap.css("h3::text").extract_first(),
            'ipa': zap.css("span.ipa::text").extract_first(),
            'id': zap.css("div span a::attr(href)").extract_first().split("?entry=")[-1],
            'gloss': zap.css("span.gloss::text").extract_first(),
            'source': "tlactalkingdict",
            'sourceurl': response.url[-1:],
            }

         # follow pagination links
        next_page = nextp
        if next_page is not None:
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, callback=self.parse)