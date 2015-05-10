root = exports ? this

root.pieChart = (data) ->
  chart:
    plotBackgroundColor: null
    plotBorderWidth: null
    plotShadow: false
  title: text: 'Messages Sent'
  tooltip: pointFormat: '<b>{point.percentage:.1f}%</b>'
  plotOptions: pie:
    allowPointSelect: true
    cursor: 'pointer'
    dataLabels:
      enabled: true
      format: '<b>{point.name}</b>: {point.percentage:.1f} %'
      style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      connectorColor: 'silver'
  series: [ type: 'pie', name: 'Messages', data: data ]

root.columnChart = (categories, series) ->
  chart: type: 'column'
  title: text: 'Monthly Messages'
  xAxis:
    categories: categories
    crosshair: true
  yAxis:
    min: 0
    title: text: 'Messages Sent'
  tooltip:
    headerFormat: '<span style="font-size:10px">{point.key}</span><table>'
    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.0f}</b></td></tr>'
    footerFormat: '</table>'
    shared: true
    useHTML: true
  plotOptions: column:
    pointPadding: 0.2
    borderWidth: 0
  series: series