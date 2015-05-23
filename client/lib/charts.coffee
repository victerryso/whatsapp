root = exports ? this

root.chart2d = (title, data, hole) ->
  chart:
    plotBackgroundColor: null
    plotBorderWidth: null
    plotShadow: false
  title: text: title
  tooltip: pointFormat: '<b>{point.percentage:.1f}%</b>'
  plotOptions: pie:
    allowPointSelect: true
    cursor: 'pointer'
    dataLabels:
      enabled: true
      format: '<b>{point.name}</b>: {point.percentage:.1f} %'
      style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      connectorColor: 'silver'
  series: [ type: 'pie', name: 'Messages', data: data, innerSize: hole ]

root.chart3d = (chart, type, title, categories, series) ->
  chart: type: chart
  title: text: title
  xAxis: categories: categories
  yAxis: min: 0, title: text: 'Messages Sent'
  legend:
    align: 'right'
    x: -30
    verticalAlign: 'top'
    y: 25
    floating: true
    backgroundColor: Highcharts.theme and Highcharts.theme.background2 or 'white'
    borderColor: '#CCC'
    borderWidth: 1
    shadow: false
  tooltip: formatter: ->
    '<b>' + @x + '</b><br/>' + @series.name + ': ' + @y + '<br/>' + 'Total: ' + @point.stackTotal
  plotOptions: column: stacking: type
  series: series

root.miniColumn = (categories, series) ->
  chart: type: 'column'
  title: text: false
  xAxis: categories: categories, labels: enabled: false
  yAxis: title: false, labels: enabled: false
  legend: enabled: false
  plotOptions: column: pointPadding: -0.33
  series: series