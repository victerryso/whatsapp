root = exports ? this

Template.home.helpers
  stats: ->
    stats = Session.get('stats')
    if stats then return stats

    stats = {}
    charts = {}
    messages = Messages.find().fetch()

    grouped = _.groupBy messages, (message) -> message.user
    _.each grouped, (array, user) ->
      return if /you/i.test user
      short = user.replace(/\s.*$/, '').toLowerCase()
      stats[short] ||= {}
      stats[short]['user'] = user
      stats[short]['array'] = array
      stats[short]['count'] = array.length
      stats[short]['imageCount'] = _.where(array, text: '<image omitted>').length

    dayCount = _.countBy messages, (message) -> message.time.getDay()
    data = _.sortBy dayCount, (value, day) -> day
    categories = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

    charts.dayCount = categories : categories, series: [ name: 'Messages', data: data ]

    monthCount = _.countBy messages, (message) ->
      year = parseInt(message.time.getFullYear()) - 2000
      month = parseInt(message.time.getMonth()) + 1
      if month < 10 then month = '0' + month
      year + '/' + month

    data = _.sortBy monthCount, (value, month) -> month
    categories = _.keys(monthCount).sort()

    charts.monthCount = categories : categories, series: [ name: 'Messages', data: data ]

    stats  = Session.set('stats', _.toArray stats)
    charts = Session.set('charts', charts)

  messageCount: ->
    stats = Session.get('stats')
    data = _.map stats, (stat) -> [stat.user, stat.count]
    pieChart(data)

  imageCount: ->
    stats = Session.get('stats')
    data = _.map stats, (stat) -> [stat.user, stat.imageCount]
    pieChart(data)

  dayCount: ->
    chart = Session.get('charts').dayCount
    columnChart(chart.categories, chart.series)

  monthCount: ->
    chart = Session.get('charts').monthCount
    columnChart(chart.categories, chart.series)