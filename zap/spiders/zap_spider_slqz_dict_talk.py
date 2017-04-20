import scrapy


class ZapSpider(scrapy.Spider):
    name = "slqztalkdict"

    start_urls = [
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=1',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=500',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=1000',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=1500',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=2000',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=2500',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=3000',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=4000',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=5000',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=6000',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=7000',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=8000',
            'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=9000',
        ]

    def parse(self, response):
        currentIndex = int(response.url.split("?entry=")[-1])+1
        nextp = 'http://talkingdictionary.swarthmore.edu/sanlucasquiavini/?entry=' + str(currentIndex)
        for zap in response.css('div.entry'):
            yield{
            'morph': zap.css("h3::text").extract_first(),
            'ipa': zap.css("span.ipa::text").extract_first(),
            'id': zap.css("div span a::attr(href)").extract_first().split("?entry=")[-1],
            'gloss': zap.css("span.gloss::text").extract_first(),
            'source': "SLQZtalkingdict",
            'sourceurl': response.url[-1:],
            }

         # follow pagination links
        next_page = nextp
        if next_page is not None:
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, callback=self.parse)