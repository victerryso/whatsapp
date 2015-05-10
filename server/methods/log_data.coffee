Meteor.methods
  logData: ->

    fs = Npm.require('fs')
    textFile = "/public/chat_log.txt"
    data = fs.readFileSync process.env.PWD + textFile, 'utf-8'

    messages = new Array
    message = new Object
    users = new Object

    regexp = /^(\d{1,2}\/\d{2}\/\d{4}\s\d{1,2}:\d{2}:\d{2}\s\wm):\s(\w*\s\w*):*\s(.*)$/

    _.each data.split(/\n/), (line) ->
      if !line # Blank Line

      else if /You were added/.test line # You were added
        # console.log line

      else if /was added/.test line # Originally added
        # console.log line

      else if /:\s\w+\s\w+\sadded\s\w+\s\w+$/.test line # Someone adding someone
        # console.log line

      else if /^\d{1,2}\/\d{2}\/\d{4}/.test line # Start/End of message
        # Create the last line
        console.log message
        if !_.isEmpty message then Messages.insert(message)

        # New line with the current
        matches = line.match(regexp)

        time = matches[1]
        date = time.split(/\//)
        day   = date[0]
        month = date[1]
        date[0] = month
        date[1] = day
        matches[1] = date.join("\/")

        message.time = matches[1]
        message.user = matches[2]
        message.text = matches[3]

      else # Same message as the previous
        message.text = message.text + line

    Messages.insert(message)