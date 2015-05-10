// Home Route
Router.route('home', {
  path: '/',
  waitOn: function() {
    return [
      Meteor.subscribe('Messages')
    ];
  }
})