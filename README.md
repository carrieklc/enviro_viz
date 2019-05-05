# Girls in in Tech, Hacking for Humanity Hackathon - May 2019

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [Girls in in Tech, Hacking for Humanity Hackathon - May 2019](#girls-in-in-tech-hacking-for-humanity-hackathon---may-2019)
- [Team Group19](#team-group19)
- [Water Footprint Visualizer](#water-footprint-visualizer)
    - [Challenge Statement: How might we use technology to educate and connect people to the natural world?](#challenge-statement-how-might-we-use-technology-to-educate-and-connect-people-to-the-natural-world)
        - [Scenario 1](#scenario-1)
            - [Motivation](#motivation)
            - [Solution](#solution)
            - [Data](#data)
            - [Next Steps / Future Enhancements](#next-steps--future-enhancements)

<!-- markdown-toc end -->

# Team Group19

|Team Member|GitHub Handle|
|------------|-------------|
|Carrie Cheung|[carrieklc](https://github.com/carrieklc)|
|Socorro Dominguez|[sedv8808](https://github.com/sedv8808)|
|Klaus Marte|[klausmcm](https://github.com/klausmcm)|
|Betty Zhou|[bettybhzhou](https://github.com/bettybhzhou)|



# Water Footprint Visualizer

## Challenge Statement: How might we use technology to educate and connect people to the natural world?

### Scenario 1
Demonstrate how can we use technology to raise awareness and get more mainstream attention to green initiatives?

#### Motivation
_"Water is essential for life. No living being on planet Earth can survive without it. It is a prerequisite for human health and well-being as well as for the preservation of the environment."_ - [United Nations Department of Economic and Social Affairs](https://www.un.org/waterforlifedecade/background.shtml)

The importance of water for sustaining the livelihood of humans, animals and plants alike is obvious, as is the fact that the amount of water we use now directly reduces the amount of water available per person for the future as the global population continues to grow. What is _not_ so obvious is that the amount of water consumed by different countries varies greatly.

Being aware of differences in water usage across nations challenges assumptions we may have about what is the "norm" regarding water use. For example, a certain amount of water can mean a 30-minute shower in one country but a 2-day drinking water supply in another country!

#### Solution

The [Water Footprint Visualizer](https://sedv8808.shinyapps.io/Enviro_viz/) is a web application that compares the water footprint of domestic water consumption (quantified as average domestic water use per person per year in m<sup>3</sup>) between different countries.

The application also communicates the positiive effect of small changes individuals could make to achieve water savings that could equate to a significant improvement in quality of life in other countries.

This app is built using R and [Shiny](https://shiny.rstudio.com/).

#### Data

Data used for this project comes from:
- [Water Footprint Network](https://waterfootprint.org/en/resources/waterstat/national-water-footprint-statistics/)**
- [Per capita water use. Water questions and answers; USGS Water Science School](https://water.usgs.gov/edu/qa-home-percapita.html)
- [Drip calculator: How much water does a leaking faucet waste? USGS Water Science School](https://water.usgs.gov/edu/activity-drip.html)
- [How Much Water Does It Take To Wash Your Own Car At Home?](https://meguiarsonline.com/forums/showthread.php?61294-How-Much-Water-Does-It-Take-To-Wash-Your-Own-Car-At-Home)

** The main data set driving the application uses data from this source. Specifically, we considered only domestic water usage statistics with blue and grey water usage combined.

#### Next Steps / Future Enhancements
The application could be extended beyond domestic water use to explore water use associated with agriculture - for example, show the effects on water use associated with meat consumption and the cultivation of [avocados](https://www.theguardian.com/commentisfree/2016/aug/12/hispters-handle-unpalatable-truth-avocado-toast) and [almonds](https://www.theguardian.com/business/2014/sep/14/alarm-almond-farmers-drain-california-dry).
