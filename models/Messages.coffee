root = exports ? this

root.Messages = new Mongo.Collection 'Messages'
Meteor.subscribe('Messages')

root.Messages.attachSchema(
  new SimpleSchema(
    time:
      type: Date

    user:
      type: String

    text:
      type: String
  )
)

root.Messages.allow
  insert : -> true

  update : -> true

  remove : -> true