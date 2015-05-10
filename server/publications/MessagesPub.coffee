root = exports ? this

Meteor.publish 'Messages', ->
  root.Messages.find()