root = exports ? this

Template.home.helpers
  total: -> Messages.find(user: $ne: 'You changed').count()
  firstDate: -> Messages.findOne({}, sort: time: 1).time.toDateString()

  stats: ->
    stats = Session.get('stats')
    if stats then return stats

    stats = {}
    charts = {}
    messages = Messages.find(user: $ne: 'You changed').fetch()

    grouped = _.groupBy messages, (message) -> message.user
    _.each grouped, (array, user) ->
      short = user.replace(/\s.*$/, '').toLowerCase()
      stats[short] ||= {}
      stats[short]['user'] = user
      stats[short]['short'] = user.split(/\s/, '')[0]
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
    Session.set('charts', charts)
    Session.set('stats', _.toArray stats)

  messageCount: ->
    stats = Session.get('stats')
    data = _.map stats, (stat) -> [stat.user, stat.count]
    chart2d('Messages Sent', data, '0%')

  imageCount: ->
    stats = Session.get('stats')
    data = _.map stats, (stat) -> [stat.user, stat.imageCount]
    chart2d('Images Sent', data, '50%')

  hourCount: ->
    chart = Session.get('charts').hourCount
    chart3d('column', 'normal', 'Hourly Messages', chart.categories, chart.series)

  dayCount: ->
    chart = Session.get('charts').dayCount
    chart3d('column', null, 'Daily Messages', chart.categories, chart.series)

  monthCount: ->
    chart = Session.get('charts').monthCount
    chart3d('line', null, 'Monthly Messages', chart.categories, chart.series)