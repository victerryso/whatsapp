root = exports ? this

Template.home.helpers
  stats: ->
    stats = Session.get('stats')
    if stats then return stats

    stats = {}
    charts = {}
    messages = Messages.find({ user: $ne: 'You changed' }, sort: time: 1).fetch()[1..-1]

    grouped = _.groupBy messages, (message) -> message.user
    _.each grouped, (array, user) ->
      short = user.replace(/\s.*$/, '').toLowerCase()
      stats[short] ||= {}
      stats[short]['user'] = user
      stats[short]['array'] = array
      stats[short]['count'] = array.length
      stats[short]['imageCount'] = _.where(array, text: '<image omitted>').length

    # Hour Chart
    categories = _.range(24)

    series = _.map grouped, (array, user) ->
      hourCount = _.countBy array, (message) -> message.time.getHours()
      name: user, data: _.map categories, (hour) -> hourCount[hour] || 0

    charts.hourCount = categories: categories, series: series

    # Day Chart
    categories = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

    series = _.map grouped, (array, user) ->
      dayCount = _.countBy array, (message) -> message.time.getDay()
      name: user, data: _.map categories, (day, index) -> dayCount[index]

    charts.dayCount = categories: categories, series: series

    # Month Count
    monthCount = _.countBy messages, (message) ->
      year = parseInt(message.time.getFullYear()) - 2000
      month = parseInt(message.time.getMonth()) + 1
      if month < 10 then month = '0' + month
      year + '/' + month
    categories = _.keys(monthCount).sort()

    series = _.map grouped, (array, user) ->
      monthCount = _.countBy array, (message) ->
        year = parseInt(message.time.getFullYear()) - 2000
        month = parseInt(message.time.getMonth()) + 1
        if month < 10 then month = '0' + month
        year + '/' + month
      name: user, data: _.sortBy monthCount, (value, month) -> month

    charts.monthCount = categories: categories, series: series

    # Store Sessions
    stats  = Session.set('stats', _.toArray stats)
    charts = Session.set('charts', charts)

  messageCount: ->
    stats = Session.get('stats')
    data = _.map stats, (stat) -> [stat.user, stat.count]
    pieChart('Messages Sent', data)

  imageCount: ->
    stats = Session.get('stats')
    data = _.map stats, (stat) -> [stat.user, stat.imageCount]
    pieChart('Images Sent', data)

  hourCount: ->
    chart = Session.get('charts').hourCount
    stackChart('Hourly Messages', chart.categories, chart.series)

  dayCount: ->
    chart = Session.get('charts').dayCount
    stackChart('Daily Messages', chart.categories, chart.series)

  monthCount: ->
    chart = Session.get('charts').monthCount
    stackChart('Monthly Messages', chart.categories, chart.series)